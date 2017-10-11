###
ENV['TERM'] = 'xterm'
bash 'env_test1' do
  code <<-EOF
  export TERM='xterm'
  EOF
end


### apihub

# db for apihub
template "/opt/bootstrap/init_mysql.sql" do
  source "bootstrap/mysql/init_mysql.sql.erb"
end

# todo
mysql_root_pwd = node['secrets']['mysql_pwd']
execute 'init db' do
  command %Q(mysql -h mysql -u root -p #{mysql_root_pwd} mysql < /opt/bootstrap/init_mysql.sql)
end
#rm -f /opt/bootstrap/init_mysql.sql


# apps
execute 'dirs' do
  command %Q(mkdir -p /var/www/apps/apihub)
end

#mkdir -p /var/www/apps/apihub/current/public/
#echo 'welcome' > '/var/www/apps/apihub/current/public/welcome.html'


node.run_state['apps'] = node['apps']


# nginx app conf
node['attributes']['apps'].each do |name, opt|
  node.run_state['app_name'] = name
  node.run_state['app'] = node['attributes']['apps'][name]


  template "/etc/nginx/sites-available/#{name}.conf" do
    source "bootstrap/apps/app.conf.erb"
    mode '0775'
  end

  # nginx server enable
  link "/etc/nginx/sites-enabled/#{name}.conf" do
    to "/etc/nginx/sites-available/#{name}.conf"
  end

end



#service nginx reload

# god

template "/opt/god/master.conf" do
  source "bootstrap/god/master.conf.erb"

end

#service god restart
