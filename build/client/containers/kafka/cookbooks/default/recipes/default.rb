['iputils-ping', 'nano', 'wget', 'software-properties-common',
 'apt-transport-https', 'softflowd', 'nfdump', 'netcat', 'tar',
 'openssh-server', 'openssh-client', 'rsync', 'openvpn', 'python3', 'hardlink'].each do |p|
  package p do
    action :install
  end
end

# execute 'add Confluent key' do
#   command 'wget -qO - http://packages.confluent.io/deb/3.1/archive.key | apt-key add -'
# end
#
# execute 'add Confluent repo' do
#   command %Q(add-apt-repository "deb [arch=amd64] http://packages.confluent.io/deb/3.1 stable main")
# end

apt_repository 'confluent' do
  uri 'http://packages.confluent.io/deb/3.1'
  components ['main', 'stable']
  arch 'amd64'
  key 'http://packages.confluent.io/deb/3.1/archive.key'
end


apt_repository 'java8' do
  uri 'ppa:webupd8team/java'
end


bash 'java-licence-agree' do
  code <<-EOH
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
  EOH
end

apt_repository 'java8' do
  uri 'ppa:webupd8team/java'
end


# apt_update 'update'
apt_update

package 'java'

package ['confluent-platform-oss-2.10', 'ntp'] do
  action :install
end

execute 'clean' do
  command 'apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*'
end

execute 'hardlink' do
  command 'hardlink -t -o -p /usr'
end