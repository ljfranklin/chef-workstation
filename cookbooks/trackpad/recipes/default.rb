package 'xserver-xorg-input-libinput'

template '/usr/share/X11/xorg.conf.d/90-libinput.conf' do
  source '90-libinput.conf'
  mode '0755'
end

