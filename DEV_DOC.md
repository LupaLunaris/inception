# DEV_DOC

## Environment Setup from Scratch
Prerequisites:
- Docker Engine
- Docker Compose plugin (`docker compose`)
- GNU Make

Project files:
- `srcs/docker-compose.yml`: service orchestration
- `srcs/requirements/*`: Dockerfiles, configs, entrypoints
- `srcs/.env`: local runtime variables (not versioned)
- `srcs/.env.example`: template for `.env`

Configuration note:
- This mandatory version uses environment variables through `srcs/.env`.
- Docker secrets are not configured in this project version.

Setup steps:
1. Copy env template:
```bash
cp srcs/.env.example srcs/.env
```
2. Fill all variables in `srcs/.env`.
3. Ensure host path exists (also handled by `make`):
```bash
mkdir -p /home/jpaulis/data/mariadb /home/jpaulis/data/wordpress
```

## Build and Launch (Makefile + Compose)
Build and start:
```bash
make
```

Equivalent direct command:
```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

Stop:
```bash
make down
```

Recreate:
```bash
make re
```

## Useful Management Commands
Containers:
```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs -f
docker compose -f srcs/docker-compose.yml restart nginx wordpress mariadb
```

Images:
```bash
docker images
```

Volumes:
```bash
docker volume ls
docker volume inspect mariadb_data
docker volume inspect wordpress_data
```

## Data Location and Persistence
Persistent data is stored through named volumes:
- `mariadb_data` -> `/var/lib/mysql` in MariaDB container
- `wordpress_data` -> `/var/www/html` in WordPress/NGINX containers

On host machine, both named volumes are configured under:
- `/home/jpaulis/data/mariadb`
- `/home/jpaulis/data/wordpress`

Data persists across container restarts and rebuilds unless volumes are explicitly removed.
