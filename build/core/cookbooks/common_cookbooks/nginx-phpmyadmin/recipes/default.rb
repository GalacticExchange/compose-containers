include_recipe 'apt'

# install phpmyadmin
package 'phpmyadmin' do
  action :install
end


# link
execute 'link' do
  command 'ln -s /usr/share/phpmyadmin/ /var/www/html/phpmyadmin'

  ignore_failure true
end

# phpmyadmin config
template '/usr/share/phpmyadmin/config.inc.php' do
  source 'config.inc.php.erb'

  owner 'root'
  group 'root'
  mode '0775'
end


# setup phpmyadmin create_tables
bash 'create tables' do
  code <<-EOH
gunzip /usr/share/doc/phpmyadmin/examples/create_tables.sql.gz;
mysql --user=root --password=#{node['mysql']['root_password']} mysql < /usr/share/doc/phpmyadmin/examples/create_tables.sql
EOH

  ignore_failure true

end


# name: restart nginx
service 'nginx' do
  action [ :enable, :start ]
end

