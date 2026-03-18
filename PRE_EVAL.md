# PRE_EVAL

This file is a practical pre-correction sheet for the mandatory part of `inception`.
It is meant to be used during a defense or a self-check: short, concrete, and focused on commands that really work with this project.

## 0) Host Setup

Ensure the expected domain resolves inside the VM:

```bash
grep -qE '(^|[[:space:]])jpaulis\.42\.fr($|[[:space:]])' /etc/hosts || echo "127.0.0.1 jpaulis.42.fr" | sudo tee -a /etc/hosts
```

Purpose:
- Make `jpaulis.42.fr` resolve locally on the VM.
- Avoid adding the same hosts entry multiple times.

Expected result:
- `jpaulis.42.fr` resolves on the VM.

## 1) Project Reset

Use a project-scoped reset instead of deleting all Docker resources on the machine:

```bash
docker compose -f srcs/docker-compose.yml down -v --remove-orphans
docker image rm nginx wordpress mariadb 2>/dev/null || true
```

If you need a full clean database and website state:

```bash
sudo rm -rf /home/jpaulis/data/mariadb/* /home/jpaulis/data/wordpress/*
```

Purpose:
- Reset only this project.
- Avoid destroying unrelated Docker resources.
- Optionally reset persistent data for a fresh mandatory test.

Expected result:
- The stack is stopped.
- Project volumes can be recreated cleanly.

## 2) Build And Run

Launch the full stack:

```bash
make
docker compose -f srcs/docker-compose.yml ps
```

Purpose:
- Build images from the project Dockerfiles.
- Start the 3 mandatory services.

Expected result:
- `nginx`, `wordpress`, and `mariadb` are running.
- No container is stuck in a restart loop.

## 3) Mandatory Checks

### A. Forbidden Options And Docker Network

If `rg` is available:

```bash
rg -n "network:\s*host|links:|--link|tail -f|sleep infinity|while true" srcs Makefile
```

If `rg` is not available:

```bash
grep -REn "network:[[:space:]]*host|links:|--link|tail -f|sleep infinity|while true" srcs Makefile
```

Check the project network:

```bash
docker network ls
docker inspect "$(docker compose -f srcs/docker-compose.yml ps -q nginx)" --format '{{range $name, $conf := .NetworkSettings.Networks}}{{$name}}{{println}}{{end}}'
```

Purpose:
- Verify that forbidden options and fake keepalive commands are absent.
- Verify that containers are attached to a real Docker network.

Expected result:
- No forbidden match in the source files.
- The `nginx` container is attached to a Compose-created network.

### B. NGINX As The Only Public Entry Point

```bash
docker compose -f srcs/docker-compose.yml ps nginx
ss -tulpen | grep -E ':80|:443|:3306|:9000'
curl -I http://jpaulis.42.fr || true
curl -k -I https://jpaulis.42.fr
```

Purpose:
- Verify that NGINX is running.
- Check which ports are listening on the VM.
- Verify that HTTPS works and HTTP is not the expected public access path.

Expected result:
- HTTPS responds on `443`.
- HTTP does not serve the expected WordPress website.

### C. TLS Check

```bash
openssl s_client -connect jpaulis.42.fr:443 -servername jpaulis.42.fr 2>/dev/null | grep -E "Protocol|Cipher|Verify return code"
```

Purpose:
- Check the negotiated TLS protocol and cipher.
- Confirm the certificate is presented correctly for `jpaulis.42.fr`.

Expected result:
- TLS details are shown.
- A self-signed certificate warning is acceptable.

### D. WordPress Installed And Accessible

Open in a browser inside the VM:
- `https://jpaulis.42.fr`
- `https://jpaulis.42.fr/wp-admin`

Purpose:
- Verify that WordPress is already installed.
- Verify access to the administration panel.
- Verify that the administrator username does not contain `admin` or `administrator`.

Expected result:
- No installation page is shown.
- Website and admin panel are reachable.

### E. Volumes And Host Persistence Paths

```bash
docker volume ls
docker volume inspect mariadb_data
docker volume inspect wordpress_data
docker volume inspect mariadb_data | grep '/home/jpaulis/data/mariadb'
docker volume inspect wordpress_data | grep '/home/jpaulis/data/wordpress'
ls -la /home/jpaulis/data
ls -la /home/jpaulis/data/wordpress | head
ls -la /home/jpaulis/data/mariadb | head
```

Purpose:
- Verify that the named volumes exist.
- Verify that they point to the expected host paths.
- Verify that real persistent files exist on the host.

Expected result:
- `mariadb_data` points to `/home/jpaulis/data/mariadb`.
- `wordpress_data` points to `/home/jpaulis/data/wordpress`.

### F. MariaDB Accessible And Not Empty

```bash
docker compose -f srcs/docker-compose.yml exec mariadb sh -lc 'mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW DATABASES;"'
```

Purpose:
- Verify that MariaDB accepts connections.
- Use the container environment variables, not the host shell variables.

Expected result:
- The `wordpress` database appears in the output.

### G. Runtime Logs

```bash
docker compose -f srcs/docker-compose.yml logs --tail=30
docker compose -f srcs/docker-compose.yml logs --tail=80 mariadb wordpress nginx
```

Purpose:
- Check recent logs for startup errors.
- Focus on the 3 mandatory services when debugging.

Expected result:
- `mariadb` is ready for connections.
- `wordpress` reaches PHP-FPM startup.
- `nginx` stays up without repeated failures.

### H. Persistence Test

1. In WordPress admin, edit a page or create content.
2. Restart the stack:

```bash
make down
make
```

3. Reload the site and confirm the change is still present.

Purpose:
- Verify that data persists across restarts.

Expected result:
- Website content and database-backed data are still present.

## 4) Defense Reminder

Be ready to explain:
- How Docker and Docker Compose work.
- Why Docker is used instead of a full VM for these services.
- Why each service runs in its own container.
- Why a Docker network is used.
- Why named volumes are used.
- Why this mandatory version uses `.env` variables and not Docker secrets.

## 5) Useful Commands

### Project Setup

- `git clone <repo_url> inception`
  Clone the project repository.
- `cd inception`
  Enter the project directory.
- `cp srcs/.env.example srcs/.env`
  Create the local environment file from the template.
- `nano srcs/.env`
  Edit the runtime configuration.
- `tree`
  Show the repository tree for a quick structure check.

### Build And Lifecycle

- `make`
  Build and start the full stack.
- `make down`
  Stop the stack.
- `make re`
  Recreate the stack.
- `make fclean`
  Stop the stack, remove project volumes, and prune unused Docker resources.
- `docker compose -f srcs/docker-compose.yml up -d`
  Start or recreate the services from Compose.
- `docker compose -f srcs/docker-compose.yml down -v --remove-orphans`
  Stop the stack and remove project volumes and orphan containers.

### Containers And Images

- `docker compose -f srcs/docker-compose.yml ps`
  Show the status of the Compose services.
- `docker ps`
  Show currently running containers.
- `docker images`
  Show locally available Docker images.
- `docker image rm nginx wordpress mariadb`
  Remove the project images so they are rebuilt on the next launch.
- `docker rm -f srcs-wordpress-1`
  Force-remove the WordPress container during debugging if needed.

### Networks

- `docker network ls`
  List Docker networks.
- `docker inspect "$(docker compose -f srcs/docker-compose.yml ps -q nginx)" --format '{{range $name, $conf := .NetworkSettings.Networks}}{{$name}}{{println}}{{end}}'`
  Show the real network name used by the running `nginx` container.

### Volumes And Host Data

- `docker volume ls`
  List Docker volumes.
- `docker volume inspect mariadb_data`
  Show details for the MariaDB volume.
- `docker volume inspect wordpress_data`
  Show details for the WordPress volume.
- `ls -la /home/jpaulis/data`
  Show the host persistence directory.
- `ls -la /home/jpaulis/data/wordpress | head`
  Inspect persisted WordPress files on the host.
- `ls -la /home/jpaulis/data/mariadb | head`
  Inspect persisted MariaDB files on the host.

### Network And Access Checks

- `ss -tulpen | grep -E ':80|:443|:3306|:9000'`
  Show listening ports on the VM.
- `curl -k -I https://jpaulis.42.fr`
  Test that the HTTPS site responds.
- `curl -I http://jpaulis.42.fr || true`
  Check that HTTP is not the expected public entrypoint.
- `openssl s_client -connect jpaulis.42.fr:443 -servername jpaulis.42.fr 2>/dev/null | grep -E "Protocol|Cipher|Verify return code"`
  Check TLS protocol, cipher, and certificate status.

### Logs And Debugging

- `docker compose -f srcs/docker-compose.yml logs --tail=30`
  Show recent logs for all services.
- `docker compose -f srcs/docker-compose.yml logs --tail=80 mariadb wordpress nginx`
  Show targeted logs for startup debugging.

### Remote Access

- `ssh <user>@<vm_ip>`
  Connect to the VM from another machine.

## 6) Notes

- `docker pull debian:12` is not required in normal use. Docker pulls the base image automatically during build if needed.
- If `rg` is not installed on the VM, use `grep` instead.
- Seeing `latest` in `docker images` for local custom images is normal when no custom tag was assigned. The subject forbids using `:latest` in image references, not Docker's local display behavior.
