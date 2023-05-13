#!/bin/bash

# wait instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done


sudo apt update -y
sudo apt install -y nginx
echo "${file_content}" > /var/www/html/index.html

service nginx start