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
  # Copy requested available features into 'enabled'
  directory File.join(bash_it_path, feature_type, "enabled") do
    owner node['my_user']
    mode '0755'
    action :create
  end

  node['bash-it'][feature_type].each do |feature|
    script_name = "#{feature}.#{feature_type}.bash"
    link File.join(bash_it_path, feature_type, "enabled", script_name) do
      owner node['my_user']
      to File.join(bash_it_path, feature_type, "available", script_name)
    end
  end

  # Copy requested custom features into 'custom'
  node['bash-it']['custom'][feature_type].each do |script|
    script_name = "#{script}.#{feature_type}.bash"
    template File.join(bash_it_path, 'custom', script_name) do
      source "custom/#{script_name}"
      owner node['my_user']
      mode "0755"
    end
  end
end
