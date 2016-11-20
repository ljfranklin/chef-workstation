package 'firefox'

# Required for HBO Now
# Steps taken from http://askubuntu.com/a/783717
package 'adobe-flashplugin' do
  action :purge
end

apt_repository "pipelight" do
  uri "ppa:pipelight/stable"
  action :add
end

package 'pipelight-multi'

execute 'pipelight-update' do
  command <<-EOH
    pipelight-plugin --update && \
    pipelight-plugin --accept --enable flash && \
    pipelight-plugin --accept --enable widevine && \
    pipelight-plugin --accept --enable silverlight && \
    pipelight-plugin --update && \
    pipelight-plugin --create-mozilla-plugins
  EOH
end
