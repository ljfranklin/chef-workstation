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

bash "set git aliases" do
  user node['my_user']
  code <<-EOH
  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.ci commit
  git config --global alias.st status
  git config --global alias.unstage 'reset HEAD --'
  git config --global alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit --all"
  git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
  EOH
end
