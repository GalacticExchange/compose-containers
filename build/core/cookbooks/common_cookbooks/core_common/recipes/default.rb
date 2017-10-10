

cookbook_file '/etc/bootstrap.sh' do
  source 'bootstrap.sh'
  action :create
end

# executable
file '/etc/bootstrap.sh' do
  mode '755'
end
