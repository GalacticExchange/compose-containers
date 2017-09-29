
# TODO install overlay?

#=========================================================================
# install consul

cookbook_file '/tmp/consul.zip' do
  source 'consul.zip'
  action :create
end

bash 'install consul' do
  code <<-EOH
    unzip /tmp/consul.zip -d /tmp/ 
    cp /tmp/consul /usr/bin/
  EOH
end

# setup consul
directory '/etc/consul'
directory '/var/log/consul'

template '/etc/consul/gex-consul.json' do
  source 'gex-consul.json.erb'
  variables(
      consul_client_addr: node['attributes'].fetch('overlay_ip'),
      consul_bind_addr: node['attributes'].fetch('overlay_ip')
  )
end

template '/etc/systemd/system/gex-consul.service' do
  source 'gex-consul.service.erb'
end

service 'gex-consul' do
  action [:enable, :start]
end

#=========================================================================

# install docker engine

execute 'add docker repo' do
  command 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'
end

execute 'update' do
  command 'apt-get update'
end

execute 'install docker-ce' do
  command 'apt-get install -y --allow-unauthenticated  docker-ce=17.03.0~ce-0~ubuntu-xenial'
end

bash 'docker post install steps' do
  code <<-EOH
    groupadd docker
    usermod -aG docker $USER
  EOH
end

# setup docker service
service 'docker' do
  action [:stop]
end

template '/lib/systemd/system/docker.service' do
  source 'docker.service.erb'
end

template '/etc/default/docker_opts' do
  source 'docker_opts.erb'
  variables(
      listen_ip: node['attributes'].fetch('overlay_ip'),
      listen_port: 2375,
      consul_ip: node['attributes'].fetch('overlay_ip'),
      consul_port: 10901
  )
end

service 'docker' do
  action [:start]
end


#=========================================================================

# install docker-compose
#

bash 'docker-compose install' do
  code <<-EOH
    curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  EOH
end

#=========================================================================


directory '/data'
