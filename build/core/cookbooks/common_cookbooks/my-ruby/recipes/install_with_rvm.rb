# depends:
# node['ruby']['version'] # example 2.2.4



=begin
template '/code/.ruby-version' do
  source "ruby_version"

  mode '0755'
end
=end

file '/code/.ruby-version' do
  content "#{node['ruby']['version']}"

  mode '0775'
end


template '/code/.gemrc' do
  source ".gemrc"

  mode '0755'
end


# install ruby
bash 'rvm' do
  code <<-EOH
/bin/bash -l -c "rvm requirements;" && /bin/bash -l -c "rvm install $(cat /code/.ruby-version)";
/bin/bash -l -c "rvm use --default $(cat /code/.ruby-version)";

  EOH
end
