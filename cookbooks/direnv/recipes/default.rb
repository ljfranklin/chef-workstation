case node['platform']
when 'arch'
  pacman_aur 'direnv'
else
  package 'direnv'
end
