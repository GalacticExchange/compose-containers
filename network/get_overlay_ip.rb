iface = `ip route |grep default |awk '{print $5}'`.strip!
ip_addr = `ifconfig #{iface} |awk 'NR==2'|awk '{print $2}'|awk -F':' '{print $2}'`
last_octet = ip_addr.split('.')[3]
overlay_ip = "51.1.0.#{50+ last_octet.to_i - 1}"

puts overlay_ip
