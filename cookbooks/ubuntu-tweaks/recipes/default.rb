execute "restart-unity" do
  user node['my_user']
  command "unity --replace &"
  action :nothing
end

schema = "org.compiz.core:/org/compiz/profiles/unity/plugins/core/"
execute "enable workspaces" do
  key = 'hsize'
  value = '4'
  user node['my_user']

  command <<-EOH
  gsettings set \
  #{schema} \
  #{key} #{value}
  EOH

  val_unchanged = <<-EOH
  VALUE=$(gsettings get #{schema} #{key})
  if [ "${VALUE}" -eq "#{value}" ]; then
    exit 0
  fi
  exit 1
  EOH

  not_if val_unchanged, :user => node['my_user']

  notifies :run, 'execute[restart-unity]', :delayed
end
