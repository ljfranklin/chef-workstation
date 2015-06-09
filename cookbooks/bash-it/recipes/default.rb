bash_it_path = "/home/#{node['my_user']}/.bash_it"

git bash_it_path do
  user node['my_user']
  repository "https://github.com/Bash-it/bash-it.git"
  revision "master"
  depth 1
  action :sync
end

template "/home/#{node['my_user']}/.bashrc" do
  source "bashrc.erb"
  owner node['my_user']
  mode "0755"
end

['aliases', 'completion', 'plugins'].each do |feature_type|
  directory File.join(bash_it_path, feature_type, "enabled") do
    owner node['my_user']
    mode '0755'
    action :create
  end

  node['bash-it'][feature_type].each do |feature|
    link File.join(bash_it_path, feature_type, "enabled", "#{feature}.#{feature_type}.bash") do
      owner node['my_user']
      to File.join(bash_it_path, feature_type, "available", "#{feature}.#{feature_type}.bash")
    end
  end
end
