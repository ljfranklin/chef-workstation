duck_dns_path = "/home/#{ENV['SUDO_USER']}/.duck-dns"
directory duck_dns_path do
  owner ENV['SUDO_USER']
  mode '0755'
end

script_path = File.join(duck_dns_path, 'update_ip')
config = data_bag_item('tokens', 'duck_dns')
template script_path do
  variables :config => config
  source 'update_ip.erb'
  owner ENV['SUDO_USER']
  mode '0755'
end

cron 'update-duck-dns-ip' do
  user ENV['SUDO_USER']
  minute '5'
  command "#{script_path} #{duck_dns_path} >/dev/null 2>&1" 
end
