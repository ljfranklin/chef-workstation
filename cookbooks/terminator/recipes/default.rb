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

apt_repository 'terminator' do
  uri 'ppa:gnome-terminator'
  distribution node['lsb']['codename']
  components ['main']
end

package 'terminator'

directory "/home/#{ENV['SUDO_USER']}/.config/terminator" do
  owner ENV['SUDO_USER']
  mode '0755'
  action :create
end

template "/home/#{ENV['SUDO_USER']}/.config/terminator/config" do
  source 'config'
  owner ENV['SUDO_USER']
  mode "0755"
end
