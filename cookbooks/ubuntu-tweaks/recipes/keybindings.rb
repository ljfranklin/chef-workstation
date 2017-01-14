# WARNING: these keybindings will clobber any existing custom keybindings
keybindings = node['ubuntu-tweaks']['keybindings']

if ENV['DBUS_SESSION_BUS_ADDRESS'].nil?
  raise 'Keyboard tweaks recipe requires $DBUS_SESSION_BUS_ADDRESS to be set. Try running chef with `sudo -E`.'
end

keybinding_plugin = 'org.gnome.settings-daemon.plugins.media-keys'

execute 'set-keybinding-list' do
  user ENV['SUDO_USER']

  keybinding_list = []
  keybindings.length.times do |i|
    keybinding_list << "'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{i}/'"
  end
  value = "[#{keybinding_list.join(',')}]"

  command GsettingsHelper.set_gsetting(keybinding_plugin, 'custom-keybindings', value)
  not_if GsettingsHelper.gsetting_unchanged?(keybinding_plugin, 'custom-keybindings', value), :user => ENV['SUDO_USER']
end

binding_count = 0
keybindings.each do |name, binding|
  key_plugin = "#{keybinding_plugin}.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{binding_count}/"
  execute "set-keybinding-name" do
    user ENV['SUDO_USER']

    value = "'#{name}'"
    command GsettingsHelper.set_gsetting(key_plugin, 'name', value)
    not_if GsettingsHelper.gsetting_unchanged?(key_plugin, 'name', value), :user => ENV['SUDO_USER']
  end
  execute "set-keybinding-command" do
    user ENV['SUDO_USER']

    value = "'#{binding['command']}'"
    command GsettingsHelper.set_gsetting(key_plugin, 'command', value)
    not_if GsettingsHelper.gsetting_unchanged?(key_plugin, 'command', value), :user => ENV['SUDO_USER']
  end
  execute "set-keybinding-binding" do
    user ENV['SUDO_USER']

    value = "'#{binding['binding']}'"
    command GsettingsHelper.set_gsetting(key_plugin, 'binding', value)
    not_if GsettingsHelper.gsetting_unchanged?(key_plugin, 'binding', value), :user => ENV['SUDO_USER']
  end
  binding_count += 1
end
