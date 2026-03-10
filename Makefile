COMPOSE_FILE = srcs/docker-compose.yml
DATA_ROOT = /home/jpaulis/data

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

.PHONY: all prepare up down re fclean
