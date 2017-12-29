bash 'install weave' do
  code <<-EOH
    weave version || {
      curl -L git.io/weave -o /usr/local/bin/weave
      chmod a+x /usr/local/bin/weave
    }
  EOH
end

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

###
# Calculating overlay IP
iface = `ip route |grep default |awk '{print $5}'`.strip!
ip_addr = `ifconfig #{iface} |awk 'NR==2'|awk '{print $2}'|awk -F':' '{print $2}'`
last_octet = ip_addr.split('.')[3]
overlay_ip = "51.1.0.#{50 + last_octet.to_i - 1}"
###

template '/etc/systemd/system/weave.service' do
  cookbook 'network'
  source 'weave_client.service.erb'
  variables(
      overlay_cidr: node['attributes'].fetch('overlay_cidr'),
      server_ip: ENV.fetch('server_ip'),
      weave_pswd: ENV.fetch('weave_pswd'),
      overlay_client_ip: overlay_ip
  )
end

execute 'daemon reload' do
  command 'systemctl daemon-reload'
end

service 'weave' do
  action [:enable, :start]
end


