package 'git'

execute "set git name" do
  command "git config --global user.name \"#{node["git"]["name"]}\""
  user node['my_user']
end

execute "set git email" do
  command "git config --global user.email \"#{node["git"]["email"]}\""
  user node['my_user']
end

execute "set default push behavior" do
  command "git config --global push.default simple"
  user node['my_user']
end
