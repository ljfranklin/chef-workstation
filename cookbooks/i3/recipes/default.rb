case node['platform']
when 'arch'
  package 'rofi'
  pacman_aur 'greenclip'
  package 'feh'
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

template '/etc/X11/xinit/xinitrc.d/60-greenclip.sh' do
  source '60-greenclip.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

directory "#{ENV['HOME']}/Pictures" do
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  mode '0755'
end

remote_file "#{ENV['HOME']}/Pictures/background.jpg" do
  source 'http://floodmagazine.com/wp-content/uploads/2016/02/NASA-travel-poster_2016_header-crop.jpg'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  mode '0755'
  action :create_if_missing
end

template '/etc/X11/xinit/xinitrc.d/60-background.sh' do
  source '60-background.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables({
    image_path: "#{ENV['HOME']}/Pictures/background.jpg",
  })
end

template "#{ENV['HOME']}/.config/i3/i3-cheat-sheet.sh" do
  source 'i3-cheat-sheet.sh.erb'
  mode '0755'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
end
