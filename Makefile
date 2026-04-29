NAME        = inception
COMPOSE     = docker compose -f srcs/docker-compose.yml
DATA_DIRS   = /home/$(shell whoami)/data/db /home/$(shell whoami)/data/wordpress

all: up

up: $(DATA_DIRS)
	$(COMPOSE) up -d --build

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

re: fclean all

$(DATA_DIRS):
	mkdir -p $@

.PHONY: all up down stop start clean fclean re