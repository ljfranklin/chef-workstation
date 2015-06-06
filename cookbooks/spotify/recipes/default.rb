apt_repository "spotify" do
  uri "http://repository.spotify.com"
  components ["stable", "non-free"]
  keyserver 'hkp://keyserver.ubuntu.com:80'
  key '94558F59'
  action :add
end

# Temporary fix until spotify updates to current version of libgcrypt
remote_file "/tmp/libgcrypt11.deb" do
  source "http://security.ubuntu.com/ubuntu/pool/main/libg/libgcrypt11/libgcrypt11_1.5.4-2ubuntu1.1_amd64.deb"
  mode 0644
end

dpkg_package "libgcrypt11" do
  source "/tmp/libgcrypt11.deb"
  action :install
end

package 'spotify-client'
