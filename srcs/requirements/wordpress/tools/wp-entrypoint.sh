#!/bin/bash
set -e

WP_PATH="/var/www/html"

# Attendre que MariaDB soit prête
echo "Waiting for MariaDB..."
while ! mysqladmin ping -h mariadb -u"${DB_USER}" -p"${DB_PASSWORD}" --silent 2>/dev/null; do
    sleep 1
done
echo "MariaDB is up!"

# Installer WordPress si pas encore fait
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root --path="${WP_PATH}"

    echo "Configuring WordPress..."
    wp config create \
        --allow-root \
        --path="${WP_PATH}" \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="mariadb:3306"

    echo "Installing WordPress..."
    wp core install \
        --allow-root \
        --path="${WP_PATH}" \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email

    echo "Creating second user..."
    wp user create \
        --allow-root \
        --path="${WP_PATH}" \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}"

    echo "WordPress installed!"
fi

# Configurer php-fpm pour écouter sur 0.0.0.0:9000
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' \
    /etc/php/7.4/fpm/pool.d/www.conf

# Lancer php-fpm en foreground
exec php-fpm7.4 -F