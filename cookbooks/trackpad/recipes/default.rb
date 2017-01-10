package 'xserver-xorg-input-libinput'

# a forum indicated this file was renamed to 60-libinput.conf in Ubuntu 16.10
template '/usr/share/X11/xorg.conf.d/90-libinput.conf' do
  source '90-libinput.conf'
  mode '0755'
end

