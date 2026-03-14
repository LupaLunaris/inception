
``
## 0) Host Setup (once)
Add hostname mapping on your VM:
```bash
sudo sh -c 'echo "127.0.0.1 jpaulis.42.fr" >> /etc/hosts'
```

## 1) Clean Start (same spirit as eval sheet)
```bash
docker stop $(docker ps -qa) 2>/dev/null || true
docker rm $(docker ps -qa) 2>/dev/null || true
docker rmi -f $(docker images -qa) 2>/dev/null || true
docker volume rm $(docker volume ls -q) 2>/dev/null || true
docker network rm $(docker network ls -q) 2>/dev/null || true
```

## 2) Build and Run
```bash
make
docker compose -f srcs/docker-compose.yml ps
```

Expected:
- 3 containers running: `nginx`, `wordpress`, `mariadb`
- no crash loop

## 3) Mandatory Technical Checks

### A. Network / forbidden options
```bash
rg -n "network: host|links:|--link" srcs Makefile
docker network ls
```
Expected:
- no forbidden match
- at least one compose network exists

### B. NGINX entrypoint + TLS only on 443
```bash
docker compose -f srcs/docker-compose.yml ps nginx
curl -I http://jpaulis.42.fr || true
curl -kI https://jpaulis.42.fr
```
Expected:
- HTTP does not serve the site
- HTTPS works with self-signed certificate

### C. WordPress installed (not installer page)
Open:
- `https://jpaulis.42.fr`
- `https://jpaulis.42.fr/wp-admin`

Expected:
- WordPress already installed
- admin user exists and does not contain `admin` / `administrator`

### D. Volumes path requirement
```bash
docker volume ls
docker volume inspect mariadb_data | rg '/home/jpaulis/data/mariadb'
docker volume inspect wordpress_data | rg '/home/jpaulis/data/wordpress'
```
Expected:
- both named volumes exist
- both point to `/home/jpaulis/data/...`

### E. MariaDB not empty and accessible
```bash
docker compose -f srcs/docker-compose.yml exec mariadb \
  mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW DATABASES;"
```
Expected:
- `wordpress` database exists

### F. Persistence test
1. In WP admin, edit a page title/content.
2. Restart stack:
```bash
make down
make
```
3. Verify edited content is still present.
