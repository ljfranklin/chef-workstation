package 'vim'
template "/home/#{node['my_user']}/.vimrc" do
  source 'vimrc.erb'
  owner node['my_user']
  mode '0755'
end

package 'vim-gnome'
template "/home/#{node['my_user']}/.gvimrc" do
  source 'gvimrc.erb'
  owner node['my_user']
  mode '0755'
end
