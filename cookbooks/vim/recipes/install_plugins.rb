vim_path = "/home/#{node['my_user']}/.vim"

node['vim']['plugins'].each do |plugin_name, plugin_uri|
  git File.join(vim_path, 'bundle', plugin_name) do
    user node['my_user']
    repository plugin_uri
    revision 'master'
    depth 1
    action :sync
  end
end
