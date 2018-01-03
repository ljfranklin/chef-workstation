package 'networkmanager'
package 'network-manager-applet'
package 'networkmanager-openvpn'
package 'gnome-keyring'

service 'NetworkManager' do
  action [:enable, :start]
end
