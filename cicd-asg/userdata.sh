#!/bin/bash

sudo apt update -y
sudo apt install apache2 -y
sudo apt install net-tools -y
sudo systemctl enable apache2 --now
echo "<center><h1>This is a ASG EC2-1 with Apache2 Webserver</h1></center>" > /var/www/html/*.html