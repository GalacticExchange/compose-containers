['iputils-ping', 'nano', 'wget', 'software-properties-common',
 'apt-transport-https', 'softflowd', 'nfdump', 'netcat', 'tar',
 'openssh-server', 'openssh-client', 'rsync', 'openvpn', 'python3', 'hardlink'].each do |p|
  package p do
    action :install
  end
end

execute 'add ethereum repo' do
  command 'add-apt-repository -y ppa:ethereum/ethereum'
end

execute 'apt update' do
  command 'apt-get update'
end

package 'ethereum' do
  action :install
end

execute 'clean' do
  command 'apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*'
end

execute 'hardlink' do
  command 'hardlink -t -o -p /usr'
end