include_recipe 'steam::open_ports'

case node['platform']
when 'ubuntu'
  package "python-apt"

  remote_file "/tmp/steam.deb" do
    source "http://media.steampowered.com/client/installer/steam.deb"
    mode 0644
  end

  dpkg_package "steam" do
    source "/tmp/steam.deb"
    action :install
  end
else
  package 'steam'
end
