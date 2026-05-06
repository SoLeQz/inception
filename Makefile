NAME        = inception
COMPOSE     = docker compose -f srcs/docker-compose.yml
DATA_DIRS   = /home/$(shell whoami)/data/db /home/$(shell whoami)/data/wordpress

all: up

up: hosts $(DATA_DIRS)
	$(COMPOSE) up -d --build

hosts:
	@grep -q "$(shell cat srcs/.env | grep DOMAIN_NAME | cut -d= -f2)" /etc/hosts || \
		echo "127.0.0.1 $(shell cat srcs/.env | grep DOMAIN_NAME | cut -d= -f2)" >> /etc/hosts

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

clean: down
	$(COMPOSE) down -v --rmi all

fclean: clean
	sudo rm -rf /home/$(shell whoami)/data
	sudo mkdir -p /home/$(shell whoami)/data/db
	sudo mkdir -p /home/$(shell whoami)/data/wordpress
	sudo chown -R $(shell whoami):$(shell whoami) /home/$(shell whoami)/data

re: fclean all

$(DATA_DIRS):
	mkdir -p $@

.PHONY: all up down stop start clean fclean re hosts
