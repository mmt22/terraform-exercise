#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl enable apache2 --now
sudo echo "<center><h1>This is a apache2 Webserver created with Terraform Script</h1></center>" > /var/www/html/index.html
sudo apt install mysql-server -y
sudo systemctl enable mysqld --now
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password123'; FLUSH PRIVILEGES;"







