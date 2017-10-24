###
ENV['TERM'] = 'xterm'
bash 'env_test1' do
  code <<-EOF
  export TERM='xterm'
  EOF
end





# mount scripts and data
=begin
node['mounts'].each do |r|
  execute 'add mount' do
    command %Q(echo '#{r}' >> /etc/fstab)
  end
end

execute 'mount all' do
  command %Q(mount -a)
end

=end



### apihub

# db for apihub
template "/opt/bootstrap/init_mysql.sql" do
  source "mysql/init_mysql.sql.erb"
end


execute 'init db' do
  command %Q(mysql -h mysql -u root -p#{node['mysql']['root_password']} mysql < /opt/bootstrap/init_mysql.sql)
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
node['apps'].each do |name, opt|
  node.run_state['app_name'] = name
  node.run_state['app'] = node['apps'][name]


  template "/etc/nginx/sites-available/#{name}.conf" do
    source "apps/app.conf.erb"
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
  source "god/master.conf.erb"

end

#service god restart
