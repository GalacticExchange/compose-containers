

###
ENV['TERM'] = 'xterm'
bash 'env_test1' do
  code <<-EOF
  export TERM='xterm'
  EOF
end


# todo: wait for deps
ruby_block 'wait for dependencies' do

  block do
    require 'socket'
    #node['dependencies'].each do |cont, port|
    node['dependencies'].each do |cont, port|

      (puts "Waiting for #{port} on #{cont}"; sleep 5) until (TCPSocket.open(cont.to_s, port.to_s) rescue nil)

      #puts "Waiting for #{port} on #{cont}"
      #port_is_open = Socket.tcp(cont.to_s, port.to_s, connect_timeout: 5) { true } #rescue false
      #exit 1 unless port_is_open
    end

    puts "We're done with deps"
  end
  action :run

end


### apihub

# db for apihub
template "/opt/bootstrap/init_mysql.sql" do
  source "mysql/init_mysql.sql.erb"
end


execute 'init db' do
  #command %Q(mysql -h mysql -u root -p#{node['mysql']['password']} mysql < /opt/bootstrap/init_mysql.sql)
  command %Q(mysql -h gexcore-mysql -u root -p#{node['secrets']['mysql_pwd']} mysql < /opt/bootstrap/init_mysql.sql)
end
#rm -f /opt/bootstrap/init_mysql.sql


# apps
execute 'dirs' do
  command %Q(mkdir -p /var/www/apps/apihub)
end

#mkdir -p /var/www/apps/apihub/current/public/
#echo 'welcome' > '/var/www/apps/apihub/current/public/welcome.html'


node.run_state['apps'] = node['attributes']['apps']

# nginx app conf
node['attributes']['apps'].each do |name, opt|
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
