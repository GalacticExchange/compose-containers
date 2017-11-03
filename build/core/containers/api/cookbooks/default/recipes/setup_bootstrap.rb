

directory '/opt/bootstrap' do
  recursive true
  action :create
end

remote_directory '/opt/bootstrap/cookbooks' do
  cookbook 'default'
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

file '/opt/bootstrap/config.json' do

  config_json = {
      attributes: node['attributes'],
      secrets: node['secrets']
  }

  #todo: debug
  Chef::Log.warn(config_json.to_json.to_s)

  content(config_json.to_json.to_s)
end

