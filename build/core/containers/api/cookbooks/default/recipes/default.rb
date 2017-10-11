############################################
# Moved from the api/recipes/build.rb (gexcloud-docker)
############################################


bash 'update' do
  code <<-EOH
    apt-get update --fix-missing
  EOH
end


# base packages
%w(net-tools netcat).each do |pkg|
  apt_package(pkg)
end


# redis client tools
%w(redis-tools).each do |pkg|
  apt_package(pkg)
end


# install docker
bash 'install docker' do
  code <<-EOH
    apt-get install -y docker
  EOH

end


# nfs client
bash 'nfs-common' do
  code <<-EOH
    apt-get install -y nfs-common
  EOH
end



### network


### hosts


# commented out - compose hosts
=begin
node['hosts'].each do |r|
  execute 'add host to /etc/hosts' do
    command %Q(echo "r[0] r[1]" >> /etc/hosts)
  end
end
=end



### root pwd
machine_pwd = node['secrets']['machine_pwd']

bash 'root pwd' do
  code <<-EOH
    echo 'root:#{machine_pwd}' | chpasswd
  EOH
end

### hosts allow/deny
template "/etc/hosts.allow" do
  cookbook "default"
  source "etc/hosts.allow.erb"
end
template "/etc/hosts.deny" do
  cookbook "default"
  source "etc/hosts.deny.erb"
end

### ssh server

execute 'enable ssh' do
  command 'rm -f /etc/service/sshd/down'
end

template "/etc/ssh/sshd_config" do
  cookbook "default"
  source "ssh/sshd_config.erb"
end

execute 'fix /var/run/sshd' do
  command 'chown root:root /var/run/sshd && chmod 700 /var/run/sshd'
end



### ssh client
template "/etc/ssh/ssh_config" do
  cookbook "default"
  source "ssh/ssh_config"
end


### ssh keys

# ssh generate
execute '_regen_ssh_host_keys' do
  command '/etc/my_init.d/00_regen_ssh_host_keys.sh > /dev/nul 2>&1'
end


# ssh key - root
template "/root/.ssh/id_rsa" do
  cookbook "default"
  source "ssh-keys/root/id_rsa"
end
template "/root/.ssh/id_rsa.pub" do
  cookbook "default"
  source "ssh-keys/root/id_rsa.pub"
end


# authorized_keys

template "/root/.ssh/authorized_keys" do
  cookbook "default"
  source "ssh/authorized_keys.erb"
end

execute 'add root id_rsa.pub to authorized keys' do
  command "cd /root/.ssh && cat id_rsa.pub >> /root/.ssh/authorized_keys"
end

## keys for deploy to github
template "/root/.ssh/config" do
  cookbook "default"
  source "ssh/config.erb"

  mode '400'
end

template "/root/.ssh/github.apihub.key" do
  cookbook "default"
  source "ssh-deploy-keys/github.apihub.key"
  mode '400'
end



### ssh server config

line = 'StrictModes no'
commented_line = /^#?\s*(StrictModes\s+[a-z]+)\b/m

ruby_block "sshd_config strict mode" do
  block do
    sed = Chef::Util::FileEdit.new('/etc/ssh/sshd_config')
    sed.search_file_replace(commented_line, line)
    sed.write_file
  end
  #only_if { ::File.readlines('/etc/ssh/sshd_config').grep(commented_limits).any? }
end


# fix permissions
execute 'fix ssh permissions /root' do
  command "chown root:root /root && chown root:root /root/.ssh && chmod 700 /root/.ssh && touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys && chmod 400 /root/.ssh/config"
end

execute 'fix ssh permissions for keys /root' do
  command "chmod 700 /root/.ssh/id_rsa && chmod 700 /root/.ssh/id_rsa.pub"
end


execute 'fix /var/run/sshd' do
  command 'chown root:root /var/run/sshd && chmod 700 /var/run/sshd'
end


# git.gex host fingerprint
#bash 'git.gex host fingerprint' do
#  code <<-EOH
#  ssh-keyscan git.gex >> /var/www/temp/111.txt
#  EOH
#end
#command 'ssh-keyscan git.gex >> /root/.ssh/known_hosts'






### nginx config

template '/etc/nginx/nginx.conf' do
  cookbook "default"
  source "nginx/nginx.conf.erb"

  mode '0775'
end



directory '/var/log/passenger/' do
  recursive true
  action :create
end

template '/etc/nginx/passenger.conf' do
  cookbook "default"
  source "passenger/passenger.conf.erb"

  mode '0775'
end




### nginx default server

execute 'nginx remove default server' do
  command 'rm -f /etc/nginx/sites-enabled/default'
end

template "/etc/nginx/sites-available/default.conf" do
  cookbook "default"
  source "nginx-sites/default.conf.erb"

  mode '0775'
end

link "/etc/nginx/sites-enabled/default.conf" do
  to "/etc/nginx/sites-available/default.conf"
end



#
execute 'reload nginx' do
  command 'service nginx restart'
end




### mysql lib, gem

#execute 'update' do
#  command 'apt-get update'
#end

bash 'update' do
  code <<-EOH
  apt-get update
  EOH

end



# mysql client
bash 'install mysql-client' do
  code <<-EOH
  apt-get install -y mysql-client
  EOH

end


# mysql lib
apt_package 'libmysqlclient-dev'


# mysql gem

bash 'mysql gem' do
  code <<-EOH
source /etc/profile.d/rvm.sh;
gem install mysql2 --no-ri --no-rdoc
  EOH
end


### libs
apt_package 'imagemagick'




### god

include_recipe 'god::install_rvm'


# god config

template "/opt/god/master.conf" do
  cookbook "default"
  source "god/master.conf.erb"

end


# god service
template '/etc/init.d/god' do
  cookbook "default"
  source 'god/etc_initd_god.erb'

  mode '0775'
end


['/etc/service/god'].each do |d|
  directory d do
    recursive true
    action :create
  end
end

template '/etc/service/god/run' do
  cookbook "default"
  source 'god/runit.sh'

  mode '0775'
end

execute 'chmod' do
  command 'chmod +x /etc/service/god/run'
end


=begin
template "/etc/my_init.d/03_god.sh" do
  source "god/init.sh"
end
execute 'chmod' do
  command 'chmod +x /etc/my_init.d/03_god.sh'
end
=end




# gems
bash 'gems' do
  code <<-EOH
source /etc/profile.d/rvm.sh;
gem install rake bundler bundle
  EOH
end


#### nodejs

execute 'repo for nodejs' do
  #command 'curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -'
  command 'curl -sL https://deb.nodesource.com/setup_6.x | bash -'
end

apt_package 'nodejs'


### bower
bash 'bower' do
  code <<-EOH
npm install -g bower;
npm install -g bower-npm-resolver;

  EOH
end

# try 2 - using execute
execute 'bower' do
  command 'npm install -g bower'
end
execute 'bower' do
  command 'npm install -g bower-npm-resolver;'
end

#
bash 'bower settings' do
  code <<-EOH
echo '{ "allow_root": true }' > /root/.bowerrc
  EOH
end


### apps

# dirs
[
    '/var/www/apps',
    '/var/www/logs',
    '/var/www/temp'
].each do |d|

  directory d do
    recursive true
    action :create
  end

end




### apps on nginx
node.run_state['apps'] = node['attributes']['apps']

node['attributes']['apps'].each do |name, opt|
  node.run_state['app_name'] = name
  node.run_state['app'] = node['attributes']['apps'][name]

  include_recipe 'app-rails'
end



### logrotate
execute 'logrotate' do
  command 'apt-get install -y logrotate'
end

node.run_state['logrotate'] = node['attributes']['logrotate']

node['attributes']['logrotate'].each do |opt|
  node.run_state['logrotate'] = opt

  template "/etc/logrotate.d/#{opt['name']}.conf" do
    cookbook "default"
    source "logrotate/logrotate.conf.erb"

    mode '0775'
  end

end


# rotate now

=begin
bash 'rotate' do
  code <<-EOH
logrotate -vf /etc/logrotate.d/{{item.name}}.conf
  EOH

  ignore_failure true
end
=end






### bootstrap scripts

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

#template "/opt/bootstrap/init_mysql.sql" do
#  source "bootstrap/init_mysql.sql.erb"
#end



=begin
template "/opt/bootstrap/configure.sh" do
  source "bootstrap/configure.sh"
end

execute 'chmod' do
  command 'chmod +x /opt/bootstrap/configure.sh'
end



template "/opt/bootstrap/init.sh" do
  source "bootstrap/init.sh.erb"
end

execute 'chmod' do
  command 'chmod +x /opt/bootstrap/init.sh'
end

=end

=begin
template "/opt/bootstrap/bootstrap.sh" do
  source "bootstrap/bootstrap.sh.erb"
end

execute 'chmod' do
  command 'chmod +x /opt/bootstrap/bootstrap.sh'
end
=end



### startup scripts for phusion

template "/etc/my_init.d/01_myinit.sh" do
  cookbook "default"
  source "init/myinit.sh.erb"
end
execute 'chmod' do
  command 'chmod +x /etc/my_init.d/01_myinit.sh'
end

template "/etc/my_init.d/02_bootstrap.sh" do
  cookbook "default"
  source "init/bootstrap.sh.erb"
end
execute 'chmod' do
  command 'chmod +x /etc/my_init.d/02_bootstrap.sh'
end






=begin
['/etc/service/provision'].each do |d|
  directory d do
    recursive true
    action :create
  end
end


template '/etc/service/provision/run' do
  source 'provision/runit.sh'

  mode '0775'
end

execute 'chmod' do
  command 'chmod +x /etc/service/provision/run'
end
=end



### prepare apihub
=begin

# ansible dir

bash 'init ansible dir' do
  code <<-EOH
  cd /var/www/ansible && git init && git remote add origin #{node['ansible_git_repo']}
  EOH

  ignore_failure true
end

# chef dir

bash 'init chef dir' do
  code <<-EOH
  cd /var/www/chef && git init && git remote add origin #{node['chef_git_repo']}
  EOH

  ignore_failure true
end



### /var/www/tests

directory '/var/www/tests' do
  recursive true
  action :create
end

bash 'init tests dir' do
  code <<-EOH
  cd /var/www/tests && git init && git remote add origin #{node['tests_git_repo']}
  EOH

  ignore_failure true
end

=end


### db - init




=begin
bash 'download apihub from git' do
  code <<-EOH
  cd /var/www/temp && git clone #{node['app_git_repo']}
  EOH

  #ignore_failure true
end


bash 'upload db' do
  code <<-EOH
  cd /var/www/temp/apihub && mysql -u <username> -p <password> -h <host-name like localhost> <database-name> < db_dump-file

  EOH

  ignore_failure true
end
=end




####

# clean
execute 'clean' do
  command <<-EOH
apt-get update && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /var/tmp/* /etc/dpkg/dpkg.cfg.d/02apt-speedup
  EOH

end

#rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/dpkg/dpkg.cfg.d/02apt-speedup

include_recipe 'default::bootstrap'