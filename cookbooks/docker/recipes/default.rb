apt_repository "docker" do
  uri "https://apt.dockerproject.org/repo"
  components ["main"]
  distribution "ubuntu-#{node['lsb']['codename']}"
  keyserver "hkp://ha.pool.sks-keyservers.net:80"
  key "58118E89F3A912897C070ADBF76221572C52609D"
  action :add
end

package "docker-engine"

group 'docker' do
  action :modify
  append true
  members [ENV['SUDO_USER']]
end

service 'docker' do
  action :enable
end
