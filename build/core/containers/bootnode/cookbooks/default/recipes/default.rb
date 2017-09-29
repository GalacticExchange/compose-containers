

package 'software-properties-common' do
  action :install
end

execute 'add ethereum repo' do
  command 'add-apt-repository -y ppa:ethereum/ethereum'
end

execute 'apt update' do
  command 'apt-get update'
end


package ['ethereum'] do
  action :install
end

execute 'clean' do
  command 'apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*'
end

