apt_repository 'nodejs' do
  uri 'https://deb.nodesource.com/node_7.x'
  components ['main']
  distribution node['lsb']['codename']
  action :add
  key 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
end

package 'nodejs'
