duck_dns_path = "/home/#{node['my_user']}/.duck-dns"
directory duck_dns_path do
  owner node['my_user']
  mode '0755'
end

script_path = File.join(duck_dns_path, 'update_ip')
config = data_bag_item('tokens', 'duck_dns')
template script_path do
  variables :config => config
  source 'update_ip.erb'
  owner node['my_user']
  mode '0755'
end

cron 'update-duck-dns-ip' do
  user node['my_user']
  minute '5'
  command "#{script_path} #{duck_dns_path} >/dev/null 2>&1" 
end
