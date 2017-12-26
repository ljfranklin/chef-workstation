case node['platform']
when 'arch'
  package 'rofi'
  pacman_group 'i3' do
    action :install
  end
else
  raise "i3 recipe only supports platform 'arch', not '#{node['platform']}'"
end

template "#{ENV['HOME']}/.xinitrc" do
  source 'xinitrc.erb'
  mode '0755'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
end

include_recipe 'fonts::default'
directory "#{ENV['HOME']}/.config/i3" do
  mode '0755'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  recursive true
end

template "#{ENV['HOME']}/.config/i3/config" do
  source 'i3config.erb'
  mode '0755'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
end

directory "#{ENV['HOME']}/.config/i3status" do
  mode '0755'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  recursive true
end

template "#{ENV['HOME']}/.config/i3status/config" do
  source 'i3statusconfig.erb'
  mode '0755'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
end
