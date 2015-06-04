
remote_file "/tmp/install_docker" do
  source "https://get.docker.com/"
  mode 0755
end

execute "install docker" do
  command "sh /tmp/install_docker"
end
