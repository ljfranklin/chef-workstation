git '/boot/grub/themes/arch-silence' do
  repository 'https://github.com/fghibellini/arch-silence'
  action :sync
end

ruby_block 'update-grub-conf' do
  block do
    file = Chef::Util::FileEdit.new('/etc/default/grub')
    line = 'GRUB_THEME="/boot/grub/themes/arch-silence/theme/theme.txt"'
    file.insert_line_if_no_match(Regexp.new(Regexp.escape(line)), line)
    file.write_file
  end
end

execute 'grub-mkconfig -o /boot/grub/grub.cfg'
