apt_repository "skype" do
  uri "http://archive.canonical.com/"
  distribution node['lsb']['codename']
  components ["partner"]
end

package "skype"
