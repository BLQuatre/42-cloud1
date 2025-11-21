#!/bin/sh
set -e

# Default timeout: 60 seconds
TIMEOUT=${DB_TIMEOUT:-60}
COUNTER=0

# Ensure required environment variables
: "${DOMAIN_NAME:?Need to set DOMAIN_NAME}"
: "${WP_SQL_HOST:?Need to set WP_SQL_HOST}"
: "${WP_SQL_DATABASE:?Need to set WP_SQL_DATABASE}"
: "${WP_SQL_USER:?Need to set WP_SQL_USER}"
: "${WP_SQL_PASSWORD:?Need to set WP_SQL_PASSWORD}"
: "${WP_ADMIN_USER:?Need to set WP_ADMIN_USER}"
: "${WP_ADMIN_EMAIL:?Need to set WP_ADMIN_EMAIL}"
: "${WP_ADMIN_PASSWORD:?Need to set WP_ADMIN_PASSWORD}"

echo "Waiting for MariaDB..."
until mariadb -h "$WP_SQL_HOST" -u "$WP_SQL_USER" -p"$WP_SQL_PASSWORD" -e "SELECT 1" &>/dev/null; do
	sleep 2
	echo "Still waiting for MariaDB..."
	COUNTER=$((COUNTER+2))
	if [ "$COUNTER" -ge "$TIMEOUT" ]; then
		echo "MariaDB did not respond within $TIMEOUT seconds."
		exit 1
	fi
done
echo "MariaDB is up!"

echo "Configuring WordPress..."
if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
	wp config create \
		--allow-root \
		--dbname="$WP_SQL_DATABASE" \
		--dbuser="$WP_SQL_USER" \
		--dbpass="$WP_SQL_PASSWORD" \
		--dbhost=mariadb \
		--locale=fr_FR
else
	echo "wp-config.php already exists."
fi

chown -R www-data:www-data /var/www/wordpress
chmod 640 /var/www/wordpress/wp-config.php

if ! wp core is-installed --allow-root; then
	wp core install \
		--url="$DOMAIN_NAME" \
		--title="Cloud-1" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root
else
	echo "WordPress is already installed."
fi

wp theme install "$THEME" --activate --allow-root || echo "$THEME already installed and active"

exec "$@"
