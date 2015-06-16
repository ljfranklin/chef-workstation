vim_path = "/home/#{node['my_user']}/.vim"

['autoload', 'bundle', 'config'].each do |dir|
  directory File.join(vim_path, dir) do
    owner node['my_user']
    mode '0755'
    action :create
  end
end

remote_file File.join(vim_path, 'autoload', 'pathogen.vim') do
  source 'https://tpo.pe/pathogen.vim'
  owner node['my_user']
  mode '0755'
end

template "/home/#{node['my_user']}/.vimrc" do
  source 'vimrc.erb'
  owner node['my_user']
  mode '0755'
end
