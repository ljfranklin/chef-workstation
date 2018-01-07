package 'wget'
package 'curl'
package 'tree'
package 'xclip'
package 'gnu-netcat'
package 'strace'
package 'openssh'
package 'jq'

case node['platform']
when 'ubuntu'
  package 'silversearcher-ag'
  package 'dnsutils'
else
  package 'the_silver_searcher'
  package 'bind-tools'
  pacman_aur 'cower' do
    gpg_key_ids ['1EB2638FF56C0C53']
  end
end
