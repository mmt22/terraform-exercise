#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl enable apache2 --now
sudo echo "<center><h1>This is a apache2 Webserver created with Terraform Script</h1></center>" > /var/www/html/index.html

