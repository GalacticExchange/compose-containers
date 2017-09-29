#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

curl --version || {
    apt-get update
    apt-get install -y curl
}

# installing chef-dk
chef-solo -v  || {
    curl -o /tmp/chefdk.deb https://packages.chef.io/files/stable/chefdk/2.3.4/ubuntu/16.04/chefdk_2.3.4-1_amd64.deb
    dpkg -i /tmp/chefdk.deb
}

chef-solo -c solo.rb -j node.json
