service 'overlay' do
  action [:disable, :stop]
end

service 'weave' do
  action [:stop]
end

ruby_block 'delete overlay setup from rc.local' do
  block do
    file = Chef::Util::FileEdit.new('/etc/rc.local')
    file.search_file_delete_line(/service overlay restart/)
    file.search_file_delete_line(/brctl addbr overlay/)
    file.search_file_delete_line(/ifconfig overlay up/)
    file.search_file_delete_line(/ip addr add 51.1.0./)
    file.write_file
  end
end


bash 'stop overlay' do
  code <<-EOH
    ifdown overlay | true
    brctl delbr overlay | true
  EOH
end



template '/etc/systemd/system/weave.service' do
  cookbook 'network'
  source 'weave_client.service.erb'
  variables(
      overlay_cidr: node['attributes'].fetch('overlay_cidr'),
      server_ip: ENV.fetch('server_ip'),
      weave_pswd: ENV.fetch('weave_pswd'),
      overlay_client_ip: ENV.fetch('overlay_client_ip')
  )
end

execute 'daemon reload' do
  command 'systemctl daemon-reload'
end

service 'weave' do
  action [:enable, :start]
end


