*This project has been created as part of the 42 curriculum by jpaulis.*

# Inception

## Description
Inception is a small Docker-based infrastructure running a WordPress website behind an NGINX reverse proxy with TLS, backed by a MariaDB database.

The mandatory stack contains exactly three services:
- `nginx` (TLS termination, public entrypoint on port 443)
- `wordpress` (PHP-FPM only, no NGINX)
- `mariadb` (database only)

Main design choices:
- One service per container.
- Custom Dockerfiles for all services.
- Debian 12 base image for all containers.
- Environment-based configuration through `srcs/.env`.
- Two named volumes for persistence, stored under `/home/jpaulis/data` on host.

Docker and project sources:
- Dockerfiles and runtime scripts are in `srcs/requirements/*`.
- Orchestration is in `srcs/docker-compose.yml`.
- Lifecycle commands are in `Makefile`.

Comparison summary:
- Virtual Machines vs Docker:
  - VMs virtualize full OS kernels and are heavier.
  - Docker shares host kernel, starts faster, and is more lightweight for service isolation.
- Secrets vs Environment Variables:
  - Env vars are simple and mandatory in this project.
  - Secrets are safer for sensitive data because they reduce accidental exposure in logs/history.
- Docker Network vs Host Network:
  - Docker network isolates services and provides service-name DNS.
  - Host network removes isolation and is forbidden by the subject.
- Docker Volumes vs Bind Mounts:
  - Volumes are Docker-managed and portable for persistent container data.
  - Bind mounts map arbitrary host paths directly and are less controlled.

## Instructions
1. Prerequisites:
- Docker Engine
- Docker Compose plugin (`docker compose`)
- GNU Make

2. Configure local hostname resolution:
- Add `jpaulis.42.fr` to your hosts file and map it to your local machine IP.

3. Create your local environment file:
- Copy `srcs/.env.example` to `srcs/.env`.
- Fill all values with your local credentials.

4. Start the infrastructure:
```bash
make
```

5. Stop the infrastructure:
```bash
make down
```

6. Clean containers/images/volumes:
```bash
make fclean
```

## Resources
- Docker docs: https://docs.docker.com/
- Compose docs: https://docs.docker.com/compose/
- NGINX docs: https://nginx.org/en/docs/
- MariaDB docs: https://mariadb.com/kb/en/documentation/
- WordPress docs: https://developer.wordpress.org/
- WP-CLI docs: https://developer.wordpress.org/cli/commands/

AI usage in this project:
- AI was used to review mandatory compliance, identify inconsistencies (domain, volumes, docs), and propose minimal refactoring steps.
- AI was not used as blind copy/paste output; every generated change was reviewed and adjusted for project constraints.
