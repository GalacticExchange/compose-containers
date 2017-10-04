#
# Cookbook Name:: my-apache
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


node.default['ipaddress'] = '1.1.1.1'
node.default['motd-attributes']['company'] = 'My Company'
node.default['motd-attributes']['message'] = "It's a wonderful day today!"


include_recipe 'my-apache::message'

