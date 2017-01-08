vim_path = "/home/#{ENV['SUDO_USER']}/.vim"

['autoload', 'bundle', 'config'].each do |dir|
  directory File.join(vim_path, dir) do
    owner ENV['SUDO_USER']
    mode '0755'
    action :create
  end
end

remote_file File.join(vim_path, 'autoload', 'pathogen.vim') do
  source 'https://tpo.pe/pathogen.vim'
  owner ENV['SUDO_USER']
  mode '0755'
end
