case node['platform']
when 'arch'
  pacman_aur 'alacritty-scrollback-git' do
    build_user ENV['SUDO_USER'] # avoids permission denied error reading ~/.cargo
  end
else
  raise "alacritty recipe only supports platform 'arch', not '#{node['platform']}'"
end

template "#{ENV['HOME']}/.config/alacritty/alacritty.yml" do
  source 'alacritty.yml'
  mode '0755'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
end
