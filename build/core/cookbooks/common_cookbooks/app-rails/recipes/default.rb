# install Rails app for Nginx+Passenger

name = node.run_state['app_name']

# dir
dir_base = "/var/www/apps/#{name}"
dir_logs = "/var/www/logs/#{name}"

[dir_base, dir_logs].each do |d|
  directory d do
    recursive true
    action :create
  end

end


# nginx server

template "/etc/nginx/sites-available/#{name}.conf" do
  source "app.conf.erb"

  mode '0775'
end


# nginx server enable
link "/etc/nginx/sites-enabled/#{name}.conf" do
  to "/etc/nginx/sites-available/#{name}.conf"
end

