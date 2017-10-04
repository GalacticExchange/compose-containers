
#
execute "apt-get-update" do
  command "apt-get update"
end

execute "apt-get-update" do
  command "apt-get update --fix-missing"
end



# some packages

apt_package 'vim'
apt_package 'nano'



### postgresql
include_recipe 'postgresql::server'
