# temporary fix until docker adds wily package
ubuntu_release = (node['lsb']['codename'] == 'wily') ? 'vivid' : node['lsb']['codename']

apt_repository "dropbox" do
  uri "http://linux.dropbox.com/ubuntu"
  distribution ubuntu_release
  components ["main"]
  keyserver "pgp.mit.edu"
  key "5044912E"
end

package "python-gpgme"
package "dropbox"
