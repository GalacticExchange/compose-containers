package ['software-properties-common', 'openvpn', 'zookeeper', 'avahi-daemon', 'dnsmasq', 'openssl', 'autofs',
         'openssh-server', 'openssh-client', 'vim', 'nano', 'curl', 'ruby-full', 'net-tools', 'htop', 'patch',
         'build-essential', 'perl', 'make', 'iputils-ping', 'logrotate', 'dnsutils', 'supervisor'] do
  action :install
end

execute 'add vagrant user' do
  command 'useradd -p $(openssl passwd -1 vagrant) vagrant'
end

package 'ufw' do
  action :purge
end

execute 'configure dnsmasq.conf' do
  command "sed -i 's/#except-interface=/except-interface=eth0/g' /etc/dnsmasq.conf"
end

['json', 'zookeeper', 'slack-notifier', 'chef', 'diplomat'].each {|g|
  gem_package g
}

cookbook_file '/tmp/consul.zip' do
  cookbook 'default'
  source 'consul.zip'
  action :create
end

execute 'install consul' do
  command 'unzip /tmp/consul.zip -d /tmp/ && cp /tmp/consul /usr/bin/'
end

include_recipe 'core_common::default'

execute 'clean' do
  command 'apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*'
end
