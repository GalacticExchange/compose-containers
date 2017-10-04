#!/bin/sh
set -e
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf  -g "daemon off;"

#/etc/init.d/nginx start
#nginx
