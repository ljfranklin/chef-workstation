case node['platform']
when 'arch'
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
