package 'lightdm'
pacman_aur 'lightdm-slick-greeter'
pacman_aur 'xss-lock-git'

service 'lightdm' do
  action :enable
end

template '/etc/lightdm/lightdm.conf' do
  source 'lightdm.conf'
  owner 'root'
  group 'root'
  mode '644'
end

template '/etc/lightdm/slick-greeter.conf' do
  source 'slick-greeter.conf.erb'
  owner 'root'
  group 'root'
  mode '644'
  variables({
    image_path: '/etc/lightdm/background',
  })
end

remote_file '/etc/lightdm/background' do
  source node['background']
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/etc/lightdm/lock-screen.sh' do
  source 'lock-screen.sh'
  owner 'root'
  group 'root'
  mode '0755'
end

template '/etc/X11/xinit/xinitrc.d/60-xss-lock.sh' do
  source '60-xss-lock.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
