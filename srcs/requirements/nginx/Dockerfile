FROM debian:12

RUN apt update && apt install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/*

COPY conf/default.conf /etc/nginx/sites-available/default

RUN mkdir -p /etc/nginx/ssl

EXPOSE 443

COPY tools/generate_ssl.sh /generate_ssl.sh
RUN chmod +x /generate_ssl.sh && /generate_ssl.sh

CMD ["nginx", "-g", "daemon off;"]