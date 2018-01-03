package 'wget'
package 'curl'
package 'tree'
package 'xclip'
package 'dnsutils'
package 'gnu-netcat'
package 'strace'

case node['platform']
when 'ubuntu'
  package 'silversearcher-ag'
else
  package 'the_silver_searcher'
end
