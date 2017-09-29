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

# doesn't work
=begin
user 'root' do
  password 'PH_GEX_PASSWD1'
end
user 'app' do
  password 'PH_GEX_PASSWD1'
end
=end

execute "setup password for root user" do
  command "echo 'root:PH_GEX_PASSWD1' | chpasswd"
end

execute "setup password for app user" do
  command "echo 'app:PH_GEX_PASSWD1' | chpasswd"
end


file '/etc/service/sshd/down' do
  action :delete
end

cookbook_file '/etc/ssh/sshd_config' do
  cookbook 'default'
  source 'sshd_config'
  action :create
end

directory '/var/run/sshd' do
  owner 'root'
  group 'root'
  mode '0700'
end

file '/etc/service/nginx/down' do
  action :delete
end

package 'imagemagick'
package 'mysql-client'

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

directory '/home/app/apss' do
  owner 'app'
  group 'app'
  mode '0777'
end

template '/etc/nginx/sites-enabled/app.conf' do
  source 'app.conf.erb'
  cookbook 'default'
  owner 'root'
  group 'root'
  mode '0755'
end