#!/bin/bash
set -e

: "${NGINX_PORT:?Missing NGINX_PORT}"
: "${PHP_FPM_PORT:?Missing PHP_FPM_PORT}"

sed \
  -e "s/__NGINX_PORT__/${NGINX_PORT}/g" \
  -e "s/__PHP_FPM_PORT__/${PHP_FPM_PORT}/g" \
  /etc/nginx/sites-available/default.template > /etc/nginx/sites-available/default

exec nginx -g "daemon off;"
