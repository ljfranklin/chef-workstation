package 'ttf-dejavu'
package 'ttf-font-awesome'
package 'noto-fonts'
pacman_aur 'ttf-material-design-icons'

# powerline
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
