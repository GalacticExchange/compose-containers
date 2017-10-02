template '/etc/systemd/system/weave.service' do
  cookbook 'network'
  source 'weave.service.erb'
  variables(
      overlay_cidr: node['attributes'].fetch('overlay_cidr'),
      weave_pswd: ENV.fetch('weave_pswd')
  )
end

execute 'daemon reload' do
  command 'systemctl daemon-reload'
end

service 'weave' do
  action [:enable, :start]
end

execute 'expose server ip' do
  command "weave expose #{node['attributes'].fetch('overlay_server_ip')}/32"
end

