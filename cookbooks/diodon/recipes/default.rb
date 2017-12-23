case node['platform']
when 'ubuntu'
  apt_repository 'diodon-ppa' do
    uri 'http://ppa.launchpad.net/diodon-team/stable/ubuntu'
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '62395ED39D71D29D9C58A226751A20CF523884B2'
    action :add
  end
  package 'diodon'
when 'arch'
  pacman_aur 'diodon' do
    action :install
  end
end
