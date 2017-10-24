###
ENV['TERM'] = 'xterm'
bash 'env_test1' do
  code <<-EOF
  export TERM='xterm'
  EOF
end


# hosts
node['hosts'].each do |r|
  execute 'add host' do
    command %Q(echo "#{r[0]} #{r[1]}" >> /etc/hosts)
  end
end


# mount scripts and data
directory '/mount/' do
  recursive true
  action :create
  mode '0775'
end

=begin
['data', 'ansible', 'vagrant', 'ansibledata'].each do |dd|
  directory '/mount/'+dd do
    recursive true
    action :create
    mode '0775'
  end
end


execute 'mount all' do
  command %Q(mount -a)
end


=end
