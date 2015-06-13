apt_repository 'terminator' do
  uri 'ppa:gnome-terminator'
  distribution 'saucy' # Latest distro included in PPA
  components ['main']
end

package 'terminator'

template "/home/#{node['my_user']}/.config/terminator/config" do
  source 'config'
  owner node['my_user']
  mode "0755"
end
