template '/etc/systemd/system/weave.service' do
  cookbook 'network'
  source 'weave.service.erb'
  variables(
      overlay_cidr: node['attributes'].fetch('overlay_cidr'),
      weave_pswd: ENV.fetch('weave_pswd'),
      overlay_server_ip: node['attributes'].fetch('overlay_server_ip')
  )
end

execute 'daemon reload' do
  command 'systemctl daemon-reload'
end

service 'weave' do
  action [:enable, :start]
end


