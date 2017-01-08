package 'vim'
template "/home/#{ENV['SUDO_USER']}/.vimrc" do
  source 'vimrc.erb'
  owner ENV['SUDO_USER']
  mode '0755'
end

directory "/home/#{ENV['SUDO_USER']}/.vim" do
  owner ENV['SUDO_USER']
  mode '0755'
  action :create
end

package 'vim-gnome'
template "/home/#{ENV['SUDO_USER']}/.gvimrc" do
  source 'gvimrc.erb'
  owner ENV['SUDO_USER']
  mode '0755'
end

execute "map-caps-to-esc" do
  user ENV['SUDO_USER']
  command "dconf write /org/gnome/desktop/input-sources/xkb-options \"['caps:escape']\""
end
