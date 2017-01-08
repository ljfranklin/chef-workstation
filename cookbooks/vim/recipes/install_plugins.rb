vim_path = "/home/#{ENV['SUDO_USER']}/.vim"

node['vim']['plugins'].each do |plugin_name, plugin_uri|
  git File.join(vim_path, 'bundle', plugin_name) do
    user ENV['SUDO_USER']
    repository plugin_uri
    revision 'master'
    depth 1
    action :sync
  end
end
