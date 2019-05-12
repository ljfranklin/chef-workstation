case node['platform']
when 'ubuntu'
  apt_repository "spotify" do
    uri "http://repository.spotify.com"
    distribution nil
    components ["stable", "non-free"]
    keyserver 'hkp://keyserver.ubuntu.com:80'
    key 'A87FF9DF48BF1C90'
    action :add
  end

  # Temporary fix until spotify updates to current version of libgcrypt
  remote_file "/tmp/libgcrypt11.deb" do
    source "https://launchpad.net/ubuntu/+archive/primary/+files/libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb"
    mode 0644
  end

  dpkg_package "libgcrypt11" do
    source "/tmp/libgcrypt11.deb"
    action :install
  end

  package 'spotify-client'
when 'arch'
  pacman_aur 'spotify' do
    gpg_key_ids ['A87FF9DF48BF1C90']
  end
end

