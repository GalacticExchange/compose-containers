

directory '/opt/bootstrap' do
  recursive true
  action :create
end

remote_directory '/opt/bootstrap/cookbooks' do
  source 'bootstrap/cookbooks'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


template "/sbin/myinit" do
  cookbook 'default'
  source "bootstrap/bootstrap.sh.erb"
end
execute 'chmod' do
  command 'chmod +x /sbin/myinit'
end
