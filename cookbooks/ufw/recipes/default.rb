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

service 'ufw' do
  action :enable
end
service 'ufw' do
  action :start
end
