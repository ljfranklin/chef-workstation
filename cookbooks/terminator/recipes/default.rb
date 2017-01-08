apt_repository 'terminator' do
  uri 'ppa:gnome-terminator'
  distribution 'saucy' # Latest distro included in PPA
  components ['main']
end

package 'terminator'

directory "/home/#{ENV['SUDO_USER']}/.config/terminator" do
  owner ENV['SUDO_USER']
  mode '0755'
  action :create
end

template "/home/#{ENV['SUDO_USER']}/.config/terminator/config" do
  source 'config'
  owner ENV['SUDO_USER']
  mode "0755"
end
