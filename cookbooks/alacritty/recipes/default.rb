package 'alacritty'

template "#{ENV['HOME']}/.config/alacritty/alacritty.yml" do
  source 'alacritty.yml'
  mode '0755'
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
end
