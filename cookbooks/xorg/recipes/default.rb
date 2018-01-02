case node['platform']
when 'arch'
  pacman_group 'xorg' do
    action :install
  end

  pacman_package 'xf86-video-intel' do
    action :install
    only_if 'lspci | grep -e VGA -e 3D | grep -i intel'
  end

  pacman_aur 'mons'
else
  raise "xorg recipe only supports platform 'arch', not '#{node['platform']}'"
end
