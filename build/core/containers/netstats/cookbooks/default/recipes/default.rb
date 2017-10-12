git '/eth-netstats' do
  repository 'https://github.com/cubedro/eth-netstats'
  revision 'master'
  action :sync
end

bash 'npm install' do
  cwd '/eth-netstats'
  code <<-EOH
    npm install
    npm install -g grunt-cli
    grunt
  EOH
end
