#!/usr/bin/env bash

### run on workstation
sudo mkdir /usr/local/share/ca-certificates/docker-dev-cert
sudo cp containers/nginx/devdockerCA.crt /usr/local/share/ca-certificates/docker-dev-cert
sudo update-ca-certificates

sudo service docker restart
