############################################
# Manual steps to add Brother printer      #
#                                          #
# 1. Visit localhost:631/admin             #
# 2. Login as root OS user                 #
# 3. Click 'Add Printer'                   #
# 4. Select 'LPD/LPR Host or Printer'      #
# 5. Enter 'lpd://192.168.1.123/binary_p1' #
#                                          #
############################################

package 'cups'
package 'cups-pdf'
package 'nss-mdns'
package 'samba'
package 'avahi'

case node['platform']
when 'arch'
  pacman_aur 'brother-hll2380dw'
end

service 'org.cups.cupsd' do
  action [:enable, :start]
end

service 'avahi-daemon' do
  action [:enable, :start]
end
