::Chef::Resource::Execute.send(:include, GsettingsHelper)
::Chef::Resource::RubyBlock.send(:include, GsettingsHelper)
::Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)

# install fonts
git File.join(Chef::Config[:file_cache_path], 'powerline') do
  repository 'https://github.com/powerline/fonts.git'
  user ENV['SUDO_USER']
  action :sync
end
bash 'install-fonts' do
  code <<-EOH
  font_dir=/usr/local/share/fonts/
  mkdir -p ${font_dir}
  find . -name '*.[o,t]tf' -type f -print0 | xargs -0 -I % cp "%" ${font_dir}
  fc-cache -f ${font_dir}
  EOH
  cwd File.join(Chef::Config[:file_cache_path], 'powerline')
end

apt_repository "tilix-ppa" do
  uri "http://ppa.launchpad.net/webupd8team/terminix/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver 'keyserver.ubuntu.com'
  key '7B2C3B0889BF5709A105D03AC2518248EEA14886'
  action :add
end

package 'tilix'

execute 'set-as-default-terminal' do
  command 'update-alternatives --set x-terminal-emulator /usr/bin/tilix'
  not_if 'update-alternatives --query x-terminal-emulator | sed -n "s/^Value: \(.*\)$/\1/p" | grep -q /usr/bin/tilix'
end

link '/etc/profile.d/vte.sh' do
  to '/etc/profile.d/vte-2.91.sh'
end

execute 'hide-tilix-titlebars' do
  user ENV['SUDO_USER']
  plugin = 'com.gexperts.Tilix.Settings'
  key = 'terminal-title-style'
  value = "'none'"
  command set_gsetting(plugin, key, value)
  not_if gsetting_unchanged?(plugin, key, value), :user => ENV['SUDO_USER']
end

execute 'set-tilix-colors' do
  user ENV['SUDO_USER']
  plugin = 'com.gexperts.Tilix.Settings'
  key = 'terminal-title-style'
  value = "'none'"
  command set_gsetting(plugin, key, value)
  not_if gsetting_unchanged?(plugin, key, value), :user => ENV['SUDO_USER']
end

# Solarized Dark theme
profile_settings = {
  'background-color' => "'#002A35'",
  'foreground-color' => "'#D3D3D7D7CFCF'",
  'palette' => "['#063541', '#DB312E', '#849900', '#B48800', '#258AD1', '#D23581', '#29A097', '#EDE7D4', '#002A35', '#CA4A15', '#576D74', '#647A82', '#829395', '#6B70C3', '#92A0A0', '#FCF5E2']",
  'font' => "'Ubuntu Mono derivative Powerline 12'",
}

# Example: gsettings set com.gexperts.Tilix.Profile:/com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/ background-color '#002A35'
profile_settings.each do |key, value|
  ruby_block "set-tilix-#{key}" do
    block do
      profile_id = shell_out(get_gsetting('com.gexperts.Tilix.ProfilesList', 'default'), :user => ENV['SUDO_USER']).stdout.gsub("'", '').strip
      shell_out(set_gsetting("com.gexperts.Tilix.Profile:/com/gexperts/Tilix/profiles/#{profile_id}/", key, value), :user => ENV['SUDO_USER']).run_command
    end
    only_if do
      profile_id = shell_out(get_gsetting('com.gexperts.Tilix.ProfilesList', 'default'), :user => ENV['SUDO_USER']).stdout.gsub("'", '').strip
      shell_out(gsetting_unchanged?("com.gexperts.Tilix.Profile:/com/gexperts/Tilix/profiles/#{profile_id}/", key, value), :user => ENV['SUDO_USER']).error?
    end
  end
end

# iTerm2-style keybindings
keybindings = {
  'app-new-session' => "'<Alt>t'",
  'session-add-down' => "'<Shift><Alt>d'",
  'session-add-right' => "'<Alt>d'",
  'session-close' => "'<Shift><Alt>w'",
  'session-switch-to-next-terminal' => "'<Alt>bracketright'",
  'session-switch-to-previous-terminal' => "'<Alt>bracketleft'",
  'terminal-close' => "'<Alt>w'",
  'terminal-maximize' => "'<Shift><Alt>Return'",
  'terminal-zoom-in' => "'<Alt>plus'",
  'terminal-zoom-out' => "'<Alt>minus'",
  'win-switch-to-next-session' => "'<Alt>braceright'",
  'win-switch-to-previous-session' => "'<Alt>braceleft'",
}

keybindings.each do |key, value|
  execute "set-tilix-keybinding-#{key}" do
    user ENV['SUDO_USER']
    plugin = 'com.gexperts.Tilix.Keybindings'
    command set_gsetting(plugin, key, value)
    not_if gsetting_unchanged?(plugin, key, value), :user => ENV['SUDO_USER']
  end
end
