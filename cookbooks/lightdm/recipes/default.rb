package 'lightdm'
pacman_aur 'lightdm-slick-greeter'
package 'light-locker'

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

template '/etc/X11/xinit/xinitrc.d/60-light-locker.sh' do
  source '60-light-locker.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
