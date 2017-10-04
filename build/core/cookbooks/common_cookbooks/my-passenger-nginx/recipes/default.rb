
# install on Ubuntu 16.04

bash 'Install PGP key and add HTTPS support for APT' do
  code <<-EOH
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
  EOH
end


# Add HTTPS support for apt
[
 'apt-transport-https',
 'ca-certificates'
].each do |p|
  apt_package p
end


bash 'Add APT repository' do
  code <<-EOH
echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list
  EOH
end



#
#include_recipe 'apt'

execute 'update' do
  command 'apt-get update'
end

# Install packages nginx, passenger
[
  'passenger',
  'nginx-extras'
].each do |p|
  apt_package p
end


# fix permissions
#execute 'fix permissions' do
#  command 'chown root:root /var/log/nginx'
#end

# enable the Passenger Nginx module

=begin
- name: Ensure passenger_root is set
lineinfile:
    dest=/etc/nginx/nginx.conf
state=present
backup=yes
regexp='#?\s*passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;'
line='passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;'


- name: Ensure passenger_ruby is set
lineinfile:
    dest=/etc/nginx/nginx.conf
state=present
backup=yes
backrefs=yes
regexp='#?\s*passenger_ruby /usr/bin/passenger_free_ruby;'
line='passenger_ruby /usr/bin/passenger_free_ruby;'
=end



# restart Nginx
=begin
- name: Restart nginx
action: service name=nginx state=restarted
=end
