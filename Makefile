build:
	docker compose -f srcs/docker-compose.yml build --no-cache

up: build
	docker compose -f srcs/docker-compose.yml up -d

stop:
	docker compose -f srcs/docker-compose.yml stop

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker system prune -af
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true

fclean: clean
	docker volume prune -f

re: fclean up

containers:
	docker compose -f srcs/docker-compose.yml ps -a

images:
	docker compose -f srcs/docker-compose.yml images

logs:
	docker compose -f srcs/docker-compose.yml logs

.PHONY: build up stop down clean fclean re containers images logs
