





# rvm - preinstall
include_recipe 'apt'

# curl
apt_package 'libcurl3'
apt_package 'curl'
apt_package 'ca-certificates'


#
include_recipe 'apt'


# packages for ruby

list = %(
  g++
  libreadline6-dev
  zlib1g-dev
  libssl-dev
  libyaml-dev
  libsqlite3-dev
  sqlite3
  autoconf
  libgdbm-dev
  libncurses5-dev
  automake
  libtool
  bison
  pkg-config
  libffi-dev
  liblzma-dev
  zlib1g-dev
  libgmp-dev
  libgmp3-dev
).split(/\n/).map{|s| s.strip}.reject(&:empty?)

list.each do |p|
  apt_package p
end




# rvm

bash 'rvm install' do
  code <<-EOH
cd /code;
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3;
  EOH
end

execute 'rvm install' do
  command '\curl -sSL https://get.rvm.io | bash -s stable'
end

# source
=begin
bash 'rvm source' do
  code <<-EOH
echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile;
echo "source $HOME/.rvm/scripts/rvm" >> ~/.bashrc
  EOH
end
=end

#echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
#echo "source $HOME/.rvm/scripts/rvm" >> ~/.bashrc

#echo "source /etc/profile.d/rvm.sh" >> ~/.bash_profile
#echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc

