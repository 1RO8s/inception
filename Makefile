


build:
	docker compose -f srcs/docker-compose.yml build --no-cache

up: build
	docker compose -f srcs/docker-compose.yml up -d


stop:
	docker compose -f srcs/docker-compose.yml stop


containers:
	docker compose -f srcs/docker-compose.yml ps -a

images:
	docker compose -f srcs/docker-compose.yml images
