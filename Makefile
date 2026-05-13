ENV_FILE			:= .env
# ENV_FILE_EXAMPLE	:= .env.example

COMPOSE				:= docker compose --env-file ${ENV_FILE}

RM					:= rm -rf

all: up

up: 
	${COMPOSE} up -d --build

attached: 
	${COMPOSE} up --build

stop: 
	${COMPOSE} stop

down: 
	${COMPOSE} down

clean: 
	$(COMPOSE) down --remove-orphans

fclean:
	$(COMPOSE) down --volumes --remove-orphans --rmi all -v
#--rmi

reset:
	{ \
		docker ps -aq | xargs -r docker stop && \
		docker ps -aq | xargs -r docker rm && \
		docker images -aq | xargs -r docker rmi -f && \
		docker volume ls -q | xargs -r docker volume rm && \
		docker network ls --filter "type=custom" -q | xargs -r docker network rm; \
	}

ps:
	${COMPOSE} ps

re: reset up

.PHONY: all up attached stop down clean fclean reset ps re