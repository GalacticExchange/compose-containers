#include_recipe 'rvm::system'



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


#
#ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
#ENV['PATH']="/usr/local/rvm/bin:#{ENV['PATH']}"




bash 'rvm install' do
  code <<-EOH
cd /code;
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3;
curl -L https://get.rvm.io | /bin/bash -s stable;
  EOH
end

# source
bash 'rvm source' do
  code <<-EOH

echo 'source /etc/profile.d/rvm.sh' >> /etc/profile;
echo 'source /etc/profile.d/rvm.sh' >> /etc/bash.bashrc;
source /etc/profile.d/rvm.sh;
  EOH
end

#echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
#echo "source $HOME/.rvm/scripts/rvm" >> ~/.bashrc

#echo "source /etc/profile.d/rvm.sh" >> ~/.bash_profile
#echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc

