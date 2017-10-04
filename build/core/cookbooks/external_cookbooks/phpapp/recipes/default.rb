include_recipe "apache2"
include_recipe "mysql::client"
include_recipe "mysql::server"


execute "apt-get-update" do
  command "apt-get update"
end

#package 'nginx' do
#  action :install
#end

apache_site "default" do
  enable true
end

