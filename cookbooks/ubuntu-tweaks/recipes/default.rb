plugins = {
  "org.compiz.core:/org/compiz/profiles/unity/plugins/core/" => {
    "hsize" => "4"
  },
  "org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/" => {
    "disable-show-desktop" => "true",
    "disable-mouse" => "true"
  },
  "org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/" => {
    "top-edge-action" => "10",
    "top-right-corner-action" => "9",
    "top-left-corner-action" => "7",
    "right-edge-action" => "6",
    "left-edge-action" => "4",
    "bottom-right-corner-action" => "3",
    "bottom-left-corner-action" => "1"
  },
  "org.gnome.desktop.input-sources" => {
    # Map caps lock to ESC for VIM
    "xkb-options" => "\"['caps:escape']\""
  }
}

plugins.each_pair do |plugin, keys|
  keys.each_pair do |key, value|
    execute "enable-workspaces" do
      user node['my_user']

      command GsettingsHelper.set_gsetting(plugin, key, value)
      not_if GsettingsHelper.gsetting_unchanged?(plugin, key, value), :user => node['my_user']
    end
  end
end
