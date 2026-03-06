all: up

up:
	docker-compose -f srcs/docker-compose.yml up -d --build

down:
	docker-compose -f srcs/docker-compose.yml down

re:
	docker-compose -f srcs/docker-compose.yml up -d --build

fclean:
	docker-compose -f srcs/docker-compose.yml down -v
	docker system prune -af

