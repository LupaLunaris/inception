#!/bin/bash
set -e

echo "[wp] entrypoint start"

# Required env
: "${MYSQL_DATABASE:?}"
: "${MYSQL_USER:?}"
: "${MYSQL_PASSWORD:?}"
: "${MARIADB_PORT:?}"
: "${DOMAIN_NAME:?}"
: "${PHP_FPM_PORT:?}"
: "${WP_TITLE:?}"
: "${WP_ADMIN_USER:?}"
: "${WP_ADMIN_PASSWORD:?}"
: "${WP_ADMIN_EMAIL:?}"
: "${WP_USER_USER:?}"
: "${WP_USER_PASSWORD:?}"
: "${WP_USER_EMAIL:?}"

echo "[wp] waiting for mariadb..."

until mysqladmin ping -h mariadb -P"$MARIADB_PORT" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
  echo "[wp] mariadb not ready yet..."
  sleep 1
done

echo "[wp] mariadb is up"

cd /var/www/html/wordpress
echo "[wp] in $(pwd)"

if [ ! -f wp-config.php ]; then
  echo "[wp] creating wp-config.php"
  wp config create \
    --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --dbhost="mariadb:$MARIADB_PORT" \
    --allow-root
fi

if ! wp core is-installed --allow-root; then
  echo "[wp] installing wordpress"
  wp core install \
    --url="https://$DOMAIN_NAME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root

  echo "[wp] creating second user"
  wp user create "$WP_USER_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASSWORD" \
    --role=author \
    --allow-root
fi

echo "[wp] starting php-fpm"
sed -i "s|^listen = .*|listen = ${PHP_FPM_PORT}|g" /etc/php/8.2/fpm/pool.d/www.conf
exec php-fpm8.2 -F
