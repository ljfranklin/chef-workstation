::Chef::Resource::Execute.send(:include, GsettingsHelper)

# some Unity settings require a desktop manager restart
service 'lightdm' do
  action :nothing # triggered via notifications
  supports :restart => true
end

node['ubuntu-tweaks']['plugins'].each_pair do |plugin, keys|
  keys.each_pair do |key, value|
    execute "set-#{plugin}-#{key}" do
      user ENV['SUDO_USER']

      command set_gsetting(plugin, key, value)
      not_if gsetting_unchanged?(plugin, key, value), :user => ENV['SUDO_USER']
      notifies :restart, 'service[lightdm]', :delayed
    end
  end
end
