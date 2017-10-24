execute "apt-get-update" do
  command "apt-get update"
end

execute "export XTERM" do
  command "export TERM=xterm"
end

# env 'TERM' do
#   value 'xterm'
# end

package 'iputils-ping'
package 'nano'

directory '/usr/local/etc/redis'

cookbook_file '/usr/local/etc/redis/redis.conf' do
  cookbook 'default'
  source 'redis.conf'
end
