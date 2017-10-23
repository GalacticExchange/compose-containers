###

execute 'update' do
  command 'apt-get update'
end

### root pwd

#TODO

### hosts allow/deny
template '/etc/hosts.allow' do
  cookbook 'default'
  source 'etc/hosts.allow.erb'
end
template '/etc/hosts.deny' do
  cookbook 'default'
  source 'etc/hosts.deny.erb'
end

package ['sudo', 'net-tools', 'sshpass', 'docker.io', 'python-pip', 'python-dev', 'openssh-server', 'openssh-client', 'software-properties-common', 'zlib1g-dev'] do
  action :install
end

bash 'install rvm' do
  code <<-EOH
    apt-add-repository -y ppa:rael-gc/rvm
    apt-get update
    apt-get install -y rvm
    source /usr/share/rvm/scripts/rvm
    rvm install 2.3.3
  EOH
end

ruby_block 'insert_line' do
  block do
    file = Chef::Util::FileEdit.new('/root/.bashrc')
    file.insert_line_if_no_match('/source /usr/share/rvm/scripts/rvm/', 'source /usr/share/rvm/scripts/rvm')
    file.write_file
  end
end


# execute 'fix /var/run/sshd' do
#   command 'chown root:root /var/run/sshd && chmod 700 /var/run/sshd'
# end


### ssh keys
directory '/root/.ssh'


bash 'install gems' do
  code <<-EOH
   source /usr/share/rvm/scripts/rvm
   gem install --no-ri --no-rdoc chef fog-aws aws-sdk slack-notifier parallel capistrano gush-mmx
  EOH
end


bash 'install net-ssh' do
  code <<-EOH
   source /usr/share/rvm/scripts/rvm
   gem install --no-ri --no-rdoc -v 4.1.0 net-ssh
  EOH
end

bash 'install diplomat' do
  code <<-EOH
   source /usr/share/rvm/scripts/rvm
   gem install --no-ri --no-rdoc -v 1.3.0 diplomat
  EOH
end


### chef gems
chef_gem 'knife-zero'


### ansible


bash 'update' do
  code <<-EOH
    apt-get update
  EOH
end


bash 'install ansible 1.9.4' do
  code <<-EOH
    pip install ansible==1.9.4
  EOH
end

directory '/etc/ansible' do
  recursive true
  action :create
end

bash 'links for ansible' do
  code <<-EOH
    ln -s /usr/local/bin/ansible /usr/bin/ansible;
  EOH

  ignore_failure true
end

bash 'links for ansible 2' do
  code <<-EOH
    ln -s /usr/local/bin/ansible-playbook /usr/bin/ansible-playbook
  EOH

  ignore_failure true
end

# ansible config
template '/etc/ansible/ansible.cfg' do
  cookbook 'default'
  source 'ansible/ansible.cfg.erb'
end

### shared data

# nfs
package 'nfs-common' do
  action :install
end


### git

bash 'git info' do
  code <<-EOH
    git config --global user.email "git@galacticexchange.io"
    git config --global user.name "git"
  EOH
end


### bootstrap scripts

directory '/opt/bootstrap' do
  recursive true
  action :create
end


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

directory '/etc/my_init.d/'

template '/etc/my_init.d/01_myinit.sh' do
  cookbook 'default'
  source 'init/myinit.sh.erb'
end
execute 'chmod' do
  command 'chmod +x /etc/my_init.d/01_myinit.sh'
end

template '/etc/my_init.d/02_bootstrap.sh' do
  cookbook 'default'
  source 'init/bootstrap.sh.erb'
end
execute 'chmod' do
  command 'chmod +x /etc/my_init.d/02_bootstrap.sh'
end

git '/tmp/ansible' do
  repository 'https://github.com/GalacticExchange/ansible.git'
  revision 'master'
  action :sync
end

git '/tmp/gexcloud' do
  repository 'https://github.com/GalacticExchange/gexcloud.git'
  revision 'master'
  action :sync
end

bash 'provisioner bundle install' do
  code <<-EOH
    source /usr/share/rvm/scripts/rvm
    cd /tmp/ansible/provisioner 
    bundle install
  EOH
end

### startup scripts for /etc/bootstrap

=begin
# run script
template "/etc/bootstrap" do
  source "bootstrap/bootstrap"
end

execute 'chmod' do
  command 'chmod +x /etc/bootstrap'
end
=end

