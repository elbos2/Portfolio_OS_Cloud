#!/bin/bash

# WordPress installatie script
# Gebruik: bash install_wordpress.sh

set -e

DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASS="WpPass123!"
WP_ADMIN_USER="admin"
WP_ADMIN_PASS="AdminPass123!"
WP_ADMIN_EMAIL="admin@example.com"
WP_DIR="/var/www/html/wordpress"
WP_URL="http://$(hostname -I | awk '{print $1}')/wordpress"

echo "=== Update systeem ==="
apt update && apt upgrade -y

echo "=== Installeer Apache, MySQL, PHP ==="
apt install -y apache2 mysql-server php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc libapache2-mod-php wget

echo "=== Maak database aan ==="
mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

echo "=== Download en installeer WordPress ==="
cd /tmp
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress ${WP_DIR}

echo "=== Configureer wp-config.php ==="
cp ${WP_DIR}/wp-config-sample.php ${WP_DIR}/wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" ${WP_DIR}/wp-config.php
sed -i "s/username_here/${DB_USER}/" ${WP_DIR}/wp-config.php
sed -i "s/password_here/${DB_PASS}/" ${WP_DIR}/wp-config.php

echo "=== Stel rechten in ==="
chown -R www-data:www-data ${WP_DIR}
chmod -R 755 ${WP_DIR}

echo "=== Installeer WP-CLI ==="
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
chmod +x /usr/local/bin/wp

echo "=== Voltooi WordPress installatie via WP-CLI ==="
sudo -u www-data wp core install \
  --path=${WP_DIR} \
  --url=${WP_URL} \
  --title="WordPress Site" \
  --admin_user=${WP_ADMIN_USER} \
  --admin_password=${WP_ADMIN_PASS} \
  --admin_email=${WP_ADMIN_EMAIL} \
  --skip-email

echo "=== Herstart services ==="
systemctl restart apache2
systemctl restart mysql

echo "=== Klaar! WordPress bereikbaar via ${WP_URL} ==="