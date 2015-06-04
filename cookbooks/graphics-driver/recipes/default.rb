reboot 'graphics-driver-reboot' do
  action :nothing # triggered via notifies
  reason 'Need to reboot after installing graphics driver'
  delay_mins 2
end

package 'nvidia-346' do
  notifies :request_reboot, 'reboot[graphics-driver-reboot]', :delayed
end
