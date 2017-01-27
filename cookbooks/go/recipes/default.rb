# adapted from https://github.com/NOX73/chef-golang/blob/master/recipes/default.rb

node.default['go']['platform'] = node['kernel']['machine'] =~ /i.86/ ? '386' : 'amd64'
node.default['go']['filename'] = "go#{node['go']['version']}.#{node['os']}-#{node['go']['platform']}.tar.gz"
node.default['go']['url'] = "http://golang.org/dl/#{node['go']['filename']}"

remote_file File.join(Chef::Config[:file_cache_path], node['go']['filename']) do
  source node['go']['url']
  owner 'root'
  mode 0644
  not_if "#{node['go']['install_dir']}/go/bin/go version | grep \"go#{node['go']['version']} \""

  notifies :run, 'bash[install-golang]', :immediately
end

bash "install-golang" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    rm -rf go
    rm -rf #{node['go']['install_dir']}/go
    tar -C #{node['go']['install_dir']} -xzf #{node['go']['filename']}
  EOH
  action :nothing
end

directory node['go']['gopath'] do
  action :create
  recursive true
  owner ENV['SUDO_USER']
end

directory node['go']['gobin'] do
  action :create
  recursive true
  owner ENV['SUDO_USER']
end

template "#{node['go']['gopath']}/.envrc" do
  source "envrc.erb"
  owner ENV['SUDO_USER']
  mode "0755"
end
