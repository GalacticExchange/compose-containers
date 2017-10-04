#
execute "apt-get-update" do
  command "apt-get update"
end



# java
include_recipe "java"
