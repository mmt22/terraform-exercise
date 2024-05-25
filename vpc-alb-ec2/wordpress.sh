#!/bin/bash
yum update -y                        # Update the package repository

# Install Apache HTTP Server
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Install PHP and required modules
yum install -y php php-mysqlnd
systemctl restart httpd

# Download and extract WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
chown -R apache:apache /var/www/html
rm -rf wordpress latest.tar.gz

# Connect to RDS database
DB_HOST="wordpressdb.crs64g8iwr6h.ap-south-1.rds.amazonaws.com"
DB_NAME="wordpressdb"
DB_USER="wpdbadmin"
DB_PASSWORD="0f58b397bc5c1f2e8"
DB_TABLE_PREFIX="wp_"  # Customize the table prefix if needed

# Configure WordPress
cd /var/www/html
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
sed -i "s/localhost/$DB_HOST/" wp-config.php
sed -i "s/wp_/$DB_TABLE_PREFIX/" wp-config.php

# Set permissions and restart Apache
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html
systemctl restart httpd
sudo dnf install mariadb105 -y
sudo dnf install telnet -y