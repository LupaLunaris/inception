# USER_DOC

## Provided Services
This stack provides:
- `nginx`: HTTPS entrypoint on port 443 only.
- `wordpress`: website application (PHP-FPM).
- `mariadb`: database used by WordPress.

## Start and Stop
Start everything from repository root:
```bash
make
```

Stop containers:
```bash
make down
```

Remove containers, volumes, and unused images:
```bash
make fclean
```

## Website and Admin Access
1. Ensure your host resolves `jpaulis.42.fr` to your local machine IP.
2. Open:
- Website: `https://jpaulis.42.fr`
- Admin: `https://jpaulis.42.fr/wp-admin`

A browser warning is expected because the certificate is self-signed.

## Credentials Location and Management
- Runtime credentials are stored in `srcs/.env` (local file).
- Template file: `srcs/.env.example`.
- Do not commit `srcs/.env` to Git.
- To rotate credentials, update `srcs/.env`, then recreate services:
```bash
make re
```

## How to Check Services
Check containers:
```bash
docker compose -f srcs/docker-compose.yml ps
```

Check logs:
```bash
docker compose -f srcs/docker-compose.yml logs --tail=100
```

Check volumes:
```bash
docker volume ls
docker volume inspect mariadb_data
docker volume inspect wordpress_data
```

Expected host paths for persistent data:
- `/home/jpaulis/data/mariadb`
- `/home/jpaulis/data/wordpress`
