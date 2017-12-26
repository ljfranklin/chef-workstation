case node['platform']
when 'ubuntu'
  apt_repository 'terminator' do
    uri 'ppa:gnome-terminator'
    distribution node['lsb']['codename']
    components ['main']
  end
end

include_recipe 'fonts::default'

package 'terminator'

directory "#{ENV['HOME']}/.config/terminator" do
  owner ENV['SUDO_USER']
  mode '0755'
  action :create
end

template "#{ENV['HOME']}/.config/terminator/config" do
  source 'config'
  owner ENV['SUDO_USER']
  mode "0755"
end
