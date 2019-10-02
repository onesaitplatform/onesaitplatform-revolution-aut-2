#!/bin/bash

echo "Starting nginx"
/usr/sbin/nginx -V
/usr/sbin/nginx -c /etc/nginx/nginx.conf

echo "Starting django"
python /app/manage.py runserver 0.0.0.0:8000

