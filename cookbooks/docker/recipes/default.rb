apt_repository "docker" do
  uri "https://get.docker.com/ubuntu"
  components ["docker", "main"]
  keyserver "hkp://p80.pool.sks-keyservers.net:80"
  key "36A1D7869245C8950F966E92D8576A8BA88D21E9"
  action :add
end

package "lxc-docker"
