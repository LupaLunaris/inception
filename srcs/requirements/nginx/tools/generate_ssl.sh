#!/bin/bash

openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /etc/nginx/ssl/nginx.key \
-out /etc/nginx/ssl/nginx.crt \
-subj "/C=BE/ST=Belgium/L=Brussels/O=42/OU=Inception/CN=jpaulis.42.be"
