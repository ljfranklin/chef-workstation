case node['platform']
when 'arch'
  pacman_aur 'chruby'
else
  raise "ruby recipe only supports platforms 'arch', not '#{node['platform']}'"
end

execute "chown -R #{ENV['SUDO_USER']}:#{ENV['SUDO_USER']} #{ENV['HOME']}/.gem"
