#!/bin/bash
set -e

# required env vars
: "${MYSQL_DATABASE:?Missing MYSQL_DATABASE}"
: "${MYSQL_USER:?Missing MYSQL_USER}"
: "${MYSQL_PASSWORD:?Missing MYSQL_PASSWORD}"
: "${MYSQL_ROOT_PASSWORD:?Missing MYSQL_ROOT_PASSWORD}"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# first boot: initialize datadir
if [ ! -f "/var/lib/mysql/.inception_init_done" ]; then
  echo "[mariadb] initializing database..."
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

  echo "[mariadb] starting temporary server..."
  mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
  pid="$!"

  echo "[mariadb] waiting for server..."
  for i in {1..30}; do
    if mariadb-admin --socket=/run/mysqld/mysqld.sock ping > /dev/null 2>&1; then
      break
    fi
    sleep 1
  done

  echo "[mariadb] applying initial SQL..."
  mariadb --protocol=socket --socket=/run/mysqld/mysqld.sock -uroot <<-SQL
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

  CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

  CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

  DROP USER IF EXISTS '${MYSQL_USER}'@'localhost';
  CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
  GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

  FLUSH PRIVILEGES;
SQL

  touch /var/lib/mysql/.inception_init_done
  chown mysql:mysql /var/lib/mysql/.inception_init_done
  echo "[mariadb] shutting down temporary server..."
  mariadb-admin --socket=/run/mysqld/mysqld.sock -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
  wait "$pid" || true
fi

echo "[mariadb] starting server..."
exec mysqld --user=mysql --datadir=/var/lib/mysql

