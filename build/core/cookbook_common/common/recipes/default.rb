

cookbook_file '/etc/bootstrap.sh' do
  source 'bootstrap.sh'
  action :create
end