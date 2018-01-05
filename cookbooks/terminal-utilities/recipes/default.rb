package 'wget'
package 'curl'
package 'tree'
package 'xclip'
package 'gnu-netcat'
package 'strace'

case node['platform']
when 'ubuntu'
  package 'silversearcher-ag'
  package 'dnsutils'
else
  package 'the_silver_searcher'
  package 'bind-tools'
end
