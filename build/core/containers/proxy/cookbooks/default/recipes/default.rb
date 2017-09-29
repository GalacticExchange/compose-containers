package ['software-properties-common', 'socat', 'openssl', 'openssh-server', 'openssh-client', 'vim',
         'nano', 'ruby-full', 'sudo', 'net-tools', 'htop', 'iputils-ping', 'make', 'patch',
         'build-essential', 'perl', 'logrotate'] do
  action :install
end

execute 'add vagrant user' do
  command 'useradd -p $(openssl passwd -1 vagrant) vagrant'
end

execute 'add socks_user user' do
  command 'useradd -p $(openssl passwd -1 887218924) socks_user'
end

['pry', 'pry-byebug', 'zookeeper', 'slack-notifier', 'diplomat'].each {|g|
  gem_package g
}

bash 'install dante proxy' do
  code <<-EOH
    wget -O /usr/src/dante-1.4.1.tar.gz https://www.inet.no/dante/files/dante-1.4.1.tar.gz
    cd /usr/src 
    tar xvfz dante-1.4.1.tar.gz
    cd dante-1.4.1
    ./configure
    make 
    make install
  EOH
end

template '/etc/init.sh' do
  cookbook 'default'
  source 'init.sh.erb'
end

execute 'make init.sh executable' do
  command 'chmod +x /etc/init.sh'
end

directory '/etc/dante_sockd' do
  action :create
end

template '/etc/dante_sockd/sockd.conf' do
  cookbook 'default'
  source 'sockd.conf.erb'
end


include_recipe 'common::default'

execute 'clean' do
  command 'apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*'
end
