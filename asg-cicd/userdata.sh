#!/bin/bash

sudo apt update -y
sudo apt install apache2 -y
sudo apt install net-tools -y
sudo systemctl enable apache2 --now
echo "This is a ASG EC2-1 with Apache2 Webserver" > /var/www/html/*.html


