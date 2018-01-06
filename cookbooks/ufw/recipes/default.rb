# Known issue:
# If the kernel is updated this recipe might fail with:
# `can't initialize iptables table `filter': Table does not exist (do you need to insmod?)`.
# To fix you need to reboot and re-run this recipe.
package 'ufw'

ufw_rules = [
  'default allow outgoing',
  'default deny incoming',
  'allow ssh',
]

ufw_rules.each do |rule|
  execute "ufw-rule-#{rule}" do
    command "ufw #{rule}"
    user 'root'
  end
end

execute 'enable-ufw' do
  command 'ufw enable'
  user 'root'
end

service 'ufw' do
  action [:enable, :start]
end
