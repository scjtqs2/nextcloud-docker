#!/bin/sh
set -e

ME=$(basename $0)

if [ $SWITCH_HTTPS ="" ]; then
 echo "IS HTTP"
else
 echo "IS HTTPS"
 sed -i "s/# fastcgi_param HTTPS on;/fastcgi_param HTTPS on;/g" /etc/nginx/nginx.conf
fi