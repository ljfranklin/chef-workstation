package 'vim'
template "/home/#{node['my_user']}/.vimrc" do
  source 'vimrc.erb'
  owner node['my_user']
  mode '0755'
end

directory "/home/#{node['my_user']}/.vim" do
  owner node['my_user']
  mode '0755'
  action :create
end

package 'vim-gnome'
template "/home/#{node['my_user']}/.gvimrc" do
  source 'gvimrc.erb'
  owner node['my_user']
  mode '0755'
end

execute "map-caps-to-esc" do
  user node['my_user']
  command "dconf write /org/gnome/desktop/input-sources/xkb-options \"['caps:escape']\""
end
