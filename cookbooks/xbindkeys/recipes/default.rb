
package 'xbindkeys'

template "#{ENV['HOME']}/.xbindkeysrc" do
  source 'xbindkeysrc.erb'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  mode '0755'
end

template "/etc/X11/xinit/xinitrc.d/60-xbindkeys.sh" do
  source '60-xbindkeys.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
