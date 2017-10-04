
# install gem with RVM
bash 'God gem' do
  code <<-EOH
source /etc/profile.d/rvm.sh;
gem install god --no-ri --no-rdoc;
rvm wrapper ruby-$(cat /code/.ruby-version) boot god
  EOH
end





# init.d script
template '/etc/init.d/god' do
  source "etc_init_d_god.erb"

  mode '0775'
end



# config
['/opt/god'].each do |d|
  directory d do
    recursive true
    action :create
  end

end


template '/opt/god/file_touched.rb' do
  source "file_touched.rb"

  mode '0775'
end

template '/opt/god/master.conf' do
  source "master.conf.erb"

  mode '0775'
end

# log
['/var/log/god'].each do |d|
  directory d do
    recursive true
    action :create
  end

end


bash 'touch log' do
  code <<-EOH
touch /var/log/god/god.log
  EOH
end


# service

['/etc/my_init.d'].each do |d|
  directory d do
    recursive true
    action :create
  end

end


template '/etc/my_init.d/god.sh' do
  source "god_start.sh"

  mode '0775'
end

=begin
template '/etc/service/god/run' do
  source 'runit.sh'

  mode '0775'
end

execute 'chmod' do
  command 'chmod +x /etc/service/god/run'
end


# autostart
bash 'autostart' do
  code <<-EOH
update-rc.d god defaults
  EOH
end

# start
bash 'start' do
  code <<-EOH
service god start
  EOH
end


=end
