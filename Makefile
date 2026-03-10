COMPOSE_FILE = srcs/docker-compose.yml
DATA_ROOT = /home/jpaulis/data
DOMAIN = jpaulis.42.fr
BROWSER_IP ?= 127.0.0.1

all: up

prepare:
	mkdir -p $(DATA_ROOT)/mariadb $(DATA_ROOT)/wordpress

up: prepare
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down

re: down up

fclean:
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -af

browser:
	@BROWSER_CMD="$$(command -v chromium || command -v chromium-browser || command -v google-chrome)"; \
	if [ -z "$$BROWSER_CMD" ]; then \
		echo "No Chromium-based browser found (chromium/chromium-browser/google-chrome)."; \
		exit 1; \
	fi; \
	"$$BROWSER_CMD" --user-data-dir=/tmp/chrome-inception \
		--host-resolver-rules="MAP $(DOMAIN) $(BROWSER_IP)" \
		"https://$(DOMAIN)"
