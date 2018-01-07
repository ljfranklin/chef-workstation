#
# Cookbook Name:: pacman
# Provider:: aur
#
# Copyright:: 2010, Opscode, Inc <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
require 'tsort'
require 'open-uri'
include Chef::Mixin::ShellOut

def create_build_dir_if_not_exists(build_dir, build_user)
    # TODO: can we use the built-in resource here?
    dir = Chef::Resource.resource_for_node('directory', node).new(build_dir)
    dir.owner(build_user)
    dir.group(build_user)
    dir.mode('0755')
    dir.recursive(true)
    provider = Chef::Provider::Directory.new(dir, run_context)
    provider.run_action('create')
end

def aurfile_path target, build_dir
    target_build = ::File.join build_dir, target.name, target.name
    aurfiles = ::Dir["#{target_build}-*.pkg.tar.xz"]
    if aurfiles.length == 0
        "#{target_build}-#{target.version}-#{target.arch}.pkg.tar.xz"
    else
        aurfiles[0]
    end
end

def already_built? target, build_dir
    ::File.exists? aurfile_path(target, build_dir)
end

def build_aur target, opts
    pkgbuild = ::File.join opts.build_dir, target.name, "PKGBUILD"
    aurfile = aurfile_path target, opts.build_dir

    Chef::Log.debug("Retrieving source for #{target.name}")
    remote_file ::File.join opts.build_dir, "#{target.name}.tar.gz" do
        source "https://aur.archlinux.org/cgit/aur.git/snapshot/#{target.name}.tar.gz"
        owner opts.build_user
        group opts.build_group
        mode 0644
        action :create_if_missing
    end

    Chef::Log.debug("Untarring source package for #{target.name}")
    execute "tar -xf #{target.name}.tar.gz" do
        cwd opts.build_dir
        user opts.build_user
        group opts.build_group
        action :run
    end

    if opts.pkgbuild_src[target.name]
        Chef::Log.debug("Replacing PKGBUILD of #{target.name} with custom version")
        template pkgbuild do
            source opts.pkgbuild_src[target.name]
            owner opts.build_user
            group opts.build_group
            mode 0644
            action :create
        end
    end

    if new_resource.options
        Chef::Log.debug("Appending #{opts.options} to configure command")
        opt = Chef::Util::FileEdit.new pkgbuild
        opt.search_file_replace(/(.\/configure.+$)/, "\\1 #{opts.options}")
        opt.write_file
    end

    skippgpcheck = opts.skippgpcheck ? " --skippgpcheck" : ""

    Chef::Log.debug("Building package #{target.name}")
    execute "makepkg #{target.name}" do
        command "makepkg -f --noconfirm#{skippgpcheck}"
        cwd ::File.join opts.build_dir, target.name
        creates aurfile
        user opts.build_user
        group opts.build_group
        environment({ 'GNUPGHOME' => opts.build_dir }.merge(opts.environment))
        action :run
    end
end

def install_aur target, opts
    execute "install AUR package #{target.name}" do
        command lazy {
            aurfile = aurfile_path target, opts.build_dir
            "pacman -U --noconfirm  --noprogressbar #{aurfile}"
        }
	user opts.install_user
	group opts.install_user
    end
end

def install_with_deps target, opts
    deps = target.all_dependencies.ordered
    deps.reject { |p| p.already_installed? }
    .each do |package|
        Chef::Log.debug("Installing #{package} as a dependency of #{target}")
        if package.is_aur?
            if not already_built? package, opts.build_dir
                build_aur package, opts
            end
            install_aur package, opts
        else
            pacman_package package.name
        end
    end
end

action :install do
    create_build_dir_if_not_exists(new_resource.build_dir, new_resource.build_user)

    new_resource.gpg_key_ids.each do |key|
        execute 'import-key' do
            user new_resource.build_user
	    group new_resource.build_user
            command "gpg --recv-key #{key}"
            environment({
                'GNUPGHOME' => new_resource.build_dir,
            })
        end
    end

    package_opts = {
      name: new_resource.name,
      build_dir: new_resource.build_dir,
      build_user: new_resource.build_user,
      install_user: new_resource.install_user,
      pkgbuild_src: new_resource.pkgbuild_src,
    }
    target = Package.aur package_opts

    if not target.already_installed?
        install_with_deps target, new_resource
        new_resource.updated_by_last_action true
    end
end

class Package
    attr_reader :build_dir, :build_user, :install_user, :pkgbuild_src, :name, :version, :arch, :dependents

    @@version_arch_re = /Version +: ([\w.-]+).+Architecture +: (\w+)/m
    @@default_arch = RUBY_PLATFORM.split("-")[0]

    def initialize opts, is_aur
	@build_dir = opts[:build_dir]
	@build_user = opts[:build_user]
	@install_user = opts[:install_user]
	@pkgbuild_src = opts[:pkgbuild_src]
        @name = opts[:name]

        info = fetch_latest_info(is_aur)
        @is_aur = is_aur
        @version = info[:version]
        @arch = info[:arch]
        @dependents = info[:dependents]
        @installed = installed_info name
    end

    def self.aur opts
        Package.new opts, true
    end

    def self.pacman opts
        Package.new opts, false
    end

    def exists_in_aur
        uri = URI.parse(pkgbuild_url(name))
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        result = http.request(request)

        http_code = result.code.to_i
        if http_code >= 200 && http_code < 300
            true
        elsif http_code == 404
            false
        else
            raise "Unexpected response while checking for existance of #{name} in AUR: #{result.body}"
        end
    end

    def to_s
        if @is_aur
            "Aur(#{@name}-#{@version})"
        else
            "Pacman(#{@name}-#{@version})"
        end
    end

    def eql? other
        @name == other.name
    end

    def hash
        @name.hash
    end

    def is_aur?
        @is_aur
    end

    def already_installed?
        @installed && @version == @installed[:version]
    end

    def all_dependencies
        AurDeps.new self
    end

    def shell_build_user(command, allow_error=false)
        cmd = Mixlib::ShellOut.new(command,
            :user => build_user,
            :group => build_user,
            :cwd => build_dir,
            :environment => {
                'GNUPGHOME' => build_dir,
            },
        ).run_command
        cmd.error! if !allow_error
        cmd.stdout.strip
    end

    def shell_install_user(command, allow_error=false)
        cmd = Mixlib::ShellOut.new(command,
            :user => install_user,
            :group => install_user,
            :cwd => build_dir,
            :environment => {
                'GNUPGHOME' => build_dir,
            },
        ).run_command
        cmd.error! if !allow_error
        cmd.stdout.strip
    end

    private

    def pkgbuild_url name
        "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=#{name}"
    end

    def fetch_latest_info is_aur
        if is_aur
            pkgbuild_download_url = pkgbuild_url(name)
            Chef::Log.debug("Downloading PKGBUILD from #{pkgbuild_download_url}...")
            pkgbuild = open(pkgbuild_download_url).read
            command = <<-FIN
                #{pkgbuild}
                echo
                echo version ${pkgver}-${pkgrel}
                echo arch ${arch}
                echo depends ${depends[@]} ${makedepends[@]}
            FIN
            data = shell_build_user(command).split("\n").last 3
            {
                :version => data[0].strip.split[1],
                :arch => data[1].include?("any") ? "any" : @@default_arch,
                :dependents => data[2].strip.split[1..-1].map do |dep|
                    # TODO: This removes version constraints like the
                    # apacman package does, in the future, try to follow
                    # these constraints instead.
                    dep.match(/[a-z0-9\-_.]+/)[0]
                end,
            }
        else
          parsed = shell_install_user("pacman -Si '#{name}'")
                .match(@@version_arch_re)
	    # TODO: raise error if length != 3
            if parsed && parsed.length == 3
                {
                    :version => parsed[1],
                    :arch => parsed[2],
                    # pacman can handle its own dependencies!
                    :dependents => [],
                }
            end
        end
    end

    def installed_info name
        Chef::Log.debug("Checking pacman for #{name}")
        parsed = shell_install_user("pacman -Qi '#{name}'", true).match(@@version_arch_re)
        if parsed && parsed.length == 3
            {
                :version => parsed[1],
                :arch => parsed[2],
            }
        else
            false
        end
    end
end

class AurDeps
    include TSort

    def initialize package
        @package = package
        @deps = build_dag @package
    end

    def tsort_each_node &block
        @deps.each_key(&block)
    end

    def tsort_each_child name, &block
        @deps[name].each(&block)
    end

    def build_dag source
        deps = {}
        queue = [source]
        while not queue.empty?
            package = queue.shift
            dependents = package.dependents.map do |dependent|
                is_pacman_pkg = package.shell_install_user("pacman -Si #{dependent}", true).length != 0
                if !is_pacman_pkg
                    out = package.shell_install_user("pacman -Ssq '^#{dependent}$'", true)
                    providers = out.split "\n"
                    if providers.length != 0
                        # TODO: Support muliple providers
                        dependent = providers[0]
                        is_pacman_pkg = true
                    end
                end

		dep_opts = {
                  name: dependent,
		  build_dir: package.build_dir,
		  build_user: package.build_user,
                  install_user: package.install_user,
                  pkgbuild_src: package.pkgbuild_src,
		}
                pkg = Package.new dep_opts, !is_pacman_pkg
                if !is_pacman_pkg && !pkg.exists_in_aur
                    raise "Could not find package #{dependent} in either pacman repos or AUR"
                end

                pkg
            end
            deps[package] = dependents
            queue += dependents
        end
        deps
    end

    def to_s
        printed = {}
        @deps.keys.each do |key|
            printed[key.to_s] = @deps[key].map { |p| p.to_s }
        end
        printed
    end

    def ordered
        tsort
    end
end
