#!/bin/bash

export TERM=xterm

cd /opt/bootstrap/
chef-client -z -j /opt/bootstrap/config.json --override-runlist "recipe[server::bootstrap]"



