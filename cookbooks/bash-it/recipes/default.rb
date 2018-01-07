bash_it_path = "/home/#{ENV['SUDO_USER']}/.bash_it"

git bash_it_path do
  user ENV['SUDO_USER']
  group ENV['SUDO_USER']
  repository "https://github.com/Bash-it/bash-it.git"
  revision "master"
  depth 1
  action :sync
end

template "/home/#{ENV['SUDO_USER']}/.bashrc" do
  source "bashrc.erb"
  owner ENV['SUDO_USER']
  group ENV['SUDO_USER']
  mode "0755"
end

['aliases', 'completion', 'plugins'].each do |feature_type|
  directory File.join(bash_it_path, feature_type, "enabled") do
    owner ENV['SUDO_USER']
    group ENV['SUDO_USER']
    mode '0755'
    action :create
  end

  # Copy requested available features into 'enabled'
  node['bash-it'][feature_type].each do |feature|
    if feature_type == 'plugins'
      script_name = "#{feature}.plugin.bash"
    else
      script_name = "#{feature}.#{feature_type}.bash"
    end
    link File.join(bash_it_path, feature_type, "enabled", script_name) do
      owner ENV['SUDO_USER']
      group ENV['SUDO_USER']
      to File.join(bash_it_path, feature_type, "available", script_name)
    end
  end

  # Copy requested custom features into 'custom'
  node['bash-it']['custom'][feature_type].each do |feature|
    if feature_type == 'plugins'
      script_name = "#{feature}.plugin.bash"
    else
      script_name = "#{feature}.#{feature_type}.bash"
    end
    template File.join(bash_it_path, 'custom', script_name) do
      source "custom/#{script_name}"
      owner ENV['SUDO_USER']
      group ENV['SUDO_USER']
      mode "0755"
    end
  end
end
