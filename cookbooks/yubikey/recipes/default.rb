apt_repository "yubico-ppa" do
  uri "http://ppa.launchpad.net/yubico/stable/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver 'keyserver.ubuntu.com'
  key '3653E21064B19D134466702E43D5C49532CBA1A9'
  action :add
end

package 'install-yubikey' do
  package_name %w(yubikey-personalization yubikey-personalization-gui yubioath-desktop)
end
