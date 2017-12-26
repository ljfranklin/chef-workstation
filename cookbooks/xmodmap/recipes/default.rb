package 'xorg-xmodmap'

template "#{ENV['HOME']}/.Xmodmap" do
  source 'Xmodmap.erb'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  mode '0755'
end

template "/etc/X11/xinit/xinitrc.d/60-xmodmap.sh" do
  source '60-xmodmap.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
