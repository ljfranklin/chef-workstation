package 'wget'
package 'curl'
package 'tree'
package 'xclip'

case node['platform']
when 'ubuntu'
  package 'silversearcher-ag'
else
  package 'the_silver_searcher'
end
