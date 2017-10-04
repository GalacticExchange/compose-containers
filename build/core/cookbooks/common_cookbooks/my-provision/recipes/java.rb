execute 'debug' do
  command 'touch /tmp/1.txt'
end

=begin
{
  "java": {
    "install_flavor": "oracle",
    "jdk_version": "7",
    "oracle": {
      "accept_oracle_download_terms": true
    }
  }
}

=end

# java
include_recipe "java"
