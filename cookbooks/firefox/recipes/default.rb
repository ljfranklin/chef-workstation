package 'firefox'

# Temporary fix until hulu ditches flash
apt_repository "hal-flash" do
  uri "ppa:flexiondotorg/hal-flash"
  distribution node['lsb']['codename']
  action :add
end

package "libhal1-flash"
