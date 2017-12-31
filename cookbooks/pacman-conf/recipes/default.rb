template '/etc/pacman.conf' do
  source 'pacman.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'sync-packages' do
  command 'pacman -Syu --noconfirm'
end
