case node['platform']
when 'ubuntu'
  package 'deps' do
    package_name %w(python-dev python-pip python3-dev python3-pip)
  end

  apt_repository 'neovim-ppa' do
    uri 'http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu'
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '9DBB0BE9366964F134855E2255F96FCF8231B6DD'
    action :add
  end
when 'arch'
  package 'python'
  package 'python-pip'
  package 'python-virtualenv'
  link '/usr/local/bin/pip3' do
    to '/usr/local/bin/pip'
  end
else
  raise "vim recipe only supports platforms 'ubuntu' and 'arch', not '#{node['platform']}'"
end

execute "chown -R #{ENV['SUDO_USER']}:#{ENV['SUDO_USER']} #{ENV['HOME']}/.cache"

package 'neovim'
execute 'gem install rcodetools'
execute 'pip install --upgrade neovim'

# alias nvim to vim by moving higher on path
link '/usr/local/bin/vim' do
  to '/usr/bin/nvim'
end

# remove .vim dir if it exists and is not a git repo
directory "#{ENV['HOME']}/.vim" do
  action :delete
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  recursive true
  not_if { File.directory?("#{ENV['HOME']}/.vim/.git") }
end

git "#{ENV['HOME']}/.vim" do
  repository "https://github.com/luan/vimfiles.git"
  user ENV['SUDO_USER']
  group ENV['SUDO_USER']
end

package 'npm'
execute "npm install -g elm --unsafe-perm=true" do
  user 'root'
  group 'root'
end

execute 'vim-install' do
  command './bin/install -n'
  cwd "#{ENV['HOME']}/.vim"
  # TODO: don't run this as root
  user 'root'
  environment 'PATH' => "/usr/local/go/bin:#{ENV['PATH']}"
end

execute "chown -R #{ENV['SUDO_USER']}:#{ENV['SUDO_USER']} #{ENV['HOME']}/.vim"
execute "chown -R #{ENV['SUDO_USER']}:#{ENV['SUDO_USER']} #{ENV['HOME']}/.local"

template "#{ENV['HOME']}/.vimrc.local" do
  source "vimrc.local"
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  mode "0755"
end
template "#{ENV['HOME']}/.vimrc.local.before" do
  source "vimrc.local.before"
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  mode "0755"
end
template "#{ENV['HOME']}/.vimrc.local.plugins" do
  source "vimrc.local.plugins"
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  mode "0755"
end
