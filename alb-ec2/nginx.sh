#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
sudo systemctl enable nginx --now
sudo echo "<center><h1>This is a Nginx Webserver created with Terraform Script</h1></center> $hostnamectl" > /var/www/html/*.html