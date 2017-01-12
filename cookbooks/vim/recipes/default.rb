package 'deps' do
  package_name %w(python-dev python-pip python3-dev python3-pip)
end

# install fonts
git File.join(Chef::Config[:file_cache_path], 'powerline') do
  repository 'https://github.com/powerline/fonts.git'
  user ENV['SUDO_USER']
  action :sync
end
bash 'install-fonts' do
  code <<-EOH
  font_dir=/usr/local/share/fonts/
  mkdir -p ${font_dir}
  find . -name '*.[o,t]tf' -type f -print0 | xargs -0 -I % cp "%" ${font_dir}
  fc-cache -f ${font_dir}
  EOH
  cwd File.join(Chef::Config[:file_cache_path], 'powerline')
end

# TODO: Couldn't get neovim to properly load the theme or font
# apt_repository 'neovim-ppa' do
#   uri 'http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu'
#   distribution node['lsb']['codename']
#   components ['main']
#   keyserver 'keyserver.ubuntu.com'
#   key '9DBB0BE9366964F134855E2255F96FCF8231B6DD'
#   action :add
# end

# package 'neovim'

# execute 'pip3 install neovim' do
#   user ENV['SUDO_USER']
# end

remote_file File.join(Chef::Config[:file_cache_path], 'vim-install.sh') do
  # source 'https://raw.githubusercontent.com/luan/vimfiles/master/bin/install'
  source 'https://raw.githubusercontent.com/ljfranklin/vimfiles/master/bin/install'
  owner ENV['SUDO_USER']
  mode '0755'
end

# remove .vim dir if it exists and is not a git repo
directory "/home/#{ENV['SUDO_USER']}/.vim" do
  action :delete
  recursive true
  not_if { File.directory?("/home/#{ENV['SUDO_USER']}/.vim/.git") }
end

execute 'vim-install' do
  command './vim-install.sh -n'
  cwd Chef::Config[:file_cache_path]
  user ENV['SUDO_USER']
  environment 'PATH' => "/usr/local/go/bin:#{ENV['PATH']}"
end

template "/home/#{ENV['SUDO_USER']}/.vimrc.local" do
  source "vimrc.local"
  owner ENV['SUDO_USER']
  mode "0755"
end
template "/home/#{ENV['SUDO_USER']}/.vimrc.local.before" do
  source "vimrc.local.before"
  owner ENV['SUDO_USER']
  mode "0755"
end
template "/home/#{ENV['SUDO_USER']}/.vimrc.local.plugins" do
  source "vimrc.local.plugins"
  owner ENV['SUDO_USER']
  mode "0755"
end
