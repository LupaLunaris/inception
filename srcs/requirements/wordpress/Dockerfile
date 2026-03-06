FROM debian:12

RUN apt update && apt install -y \
    php php-fpm php-mysql curl mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# php-fpm listen on 9000 (TCP)
RUN sed -i 's|^listen = .*|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf

# install wp-cli
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html
WORKDIR /var/www/html

RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz \
    && rm latest.tar.gz \
    && chown -R www-data:www-data /var/www/html

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
