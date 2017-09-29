['iputils-ping', 'nano', 'wget', 'software-properties-common',
 'apt-transport-https', 'softflowd', 'nfdump', 'netcat', 'tar',
 'openssh-server', 'openssh-client', 'rsync', 'openvpn', 'python2.7', 'hardlink'].each do |p|
  package p do
    action :install
  end
end

execute 'add Confluent key' do
  command 'wget -qO - http://packages.confluent.io/deb/3.1/archive.key | apt-key add -'
end

# apt_repository 'confluent' do
#   uri 'http://packages.confluent.io/deb/3.1'
#   components ['main', 'stable']
#   arch 'amd64'
# end

execute 'add Confluent repo' do
  command %Q(add-apt-repository "deb [arch=amd64] http://packages.confluent.io/deb/3.1 stable main")
end

#apt_repository 'gluster' do
#  uri          'ppa:gluster/glusterfs-3.8'
#end

execute 'add ethereum repo' do
  command 'add-apt-repository -y ppa:ethereum/ethereum'
end


# apt_update 'update'
execute 'apt update' do
  command 'apt-get update'
end

package ['confluent-platform-oss-2.10', 'ntp', 'ethereum'] do
  action :install
end

execute 'clean' do
  command 'apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*'
end

execute 'hardlink' do
  command 'hardlink -t -o -p /usr'
end