# debug
file '/tmp/init.txt' do
  content "new world "
end


#
execute "apt-get-update" do
  command "apt-get update"
end


# supervisor
#include_recipe 'supervisor::default'

# supervisord
include_recipe 'supervisord::default'


# supervisord
#execute "supervisord" do
#  command 'apt-get install -y supervisor'
#end

#execute "dir for supervisord" do
#  command 'mkdir -p /var/log/supervisor'
#end



# mysql

mysql_service 'default' do
  version '5.6'
  #bind_address '0.0.0.0'
  port '3306'
  #data_dir '/data'

  #provider Chef::Provider::Package::Apt
  #provider Chef::Provider::MysqlServiceSystemd
  #provider Chef::Provider::MysqlServiceBase

  initial_root_password node['mysql']['root_password']
  action [:create]
end

mysql_client 'default' do
  action :create
end


# mysql service for supervisor // from supervisor cookbook
=begin
supervisor_service 'mysql' do
  action [:enable, :start]
  command '/usr/sbin/mysqld --defaults-file=/etc/mysql-default/my.cnf --basedir=/usr --pid-file=/var/run/mysql-default/mysqld.pid'
  autostart true
  autorestart true
  user 'mysql'
end
=end

# mysql service for supervisor // from supervisord cookbook
supervisord_program 'mysql' do
  action [ :supervise, :start ]
  command '/usr/sbin/mysqld --defaults-file=/etc/mysql-default/my.cnf --basedir=/usr --pid-file=/var/run/mysql-default/mysqld.pid'
  autostart true
  autorestart true
  user 'mysql'
end


# java
#include_recipe "java"




#cookbook_file "/etc/supervisor/conf.d/supervisord.conf" do
#  source "supervisord.conf"
#  owner 'root'
# group 'root'
#  mode 0755
#  action :create
#end


### custom

# copy configure file
#cookbook_file '/tmp/configure.rb' do
#  source 'configure.php'
#  owner 'root'
#  group 'root'
#  mode '0775'
#  action :create
#end
