FROM debian:12

ARG NGINX_PORT=443

RUN apt update && apt install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/*

COPY conf/default.conf /etc/nginx/sites-available/default.template
COPY tools/start.sh /start.sh

RUN mkdir -p /etc/nginx/ssl

EXPOSE ${NGINX_PORT}

COPY tools/generate_ssl.sh /generate_ssl.sh
RUN chmod +x /generate_ssl.sh /start.sh && /generate_ssl.sh

CMD ["/start.sh"]
