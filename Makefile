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

.PHONY: all prepare up down re fclean browser browser-opera

browser-opera:
	@OPERA_CMD="$$(command -v opera-gx || command -v opera)"; \
	if [ -z "$$OPERA_CMD" ]; then \
		echo "Opera/Opera GX not found (opera-gx/opera)."; \
		exit 1; \
	fi; \
	"$$OPERA_CMD" --user-data-dir=/tmp/opera-gx-inception \
		--host-resolver-rules="MAP $(DOMAIN) $(BROWSER_IP)" \
		"https://$(DOMAIN)"

# Windows PowerShell example (run manually):
# & "C:\Users\<USER>\AppData\Local\Programs\Opera GX\launcher.exe" `
#   --user-data-dir="$env:TEMP\opera-gx-inception" `
#   --host-resolver-rules="MAP jpaulis.42.fr 127.0.0.1" `
#   "https://jpaulis.42.fr"
