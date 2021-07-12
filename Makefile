DOCKER_IMAGE_VERSION ?= latest
DOCKER_IMAGE = devlm/cdap:$(DOCKER_IMAGE_VERSION)
COMPOSE_BUILD_MYIMAGE = DOCKER_IMAGE=$(DOCKER_IMAGE) docker-compose build --no-cache myimage
COMPOSE_RUN_MYIMAGE = DOCKER_IMAGE=$(DOCKER_IMAGE) docker-compose run --rm myimage
COMPOSE_RUN_MUSKETEERS = DOCKER_IMAGE=$(DOCKER_IMAGE) docker-compose run --rm musketeers
COMPOSE_PULL = DOCKER_IMAGE=$(DOCKER_IMAGE) docker-compose pull
ENVFILE ?= env.template

all:
	$(MAKE) envfile clone build clean

ciPush: envfile clone build push clean

envfile:
	cp -f $(ENVFILE) .env

clone:
	$(COMPOSE_RUN_MUSKETEERS) git submodule update --remote --recursive --init

build:
	$(COMPOSE_BUILD_MYIMAGE)

push: envfile
	$(COMPOSE_RUN_MUSKETEERS) docker push ${DOCKER_IMAGE}

clean:
	docker-compose down --remove-orphans
	rm -f .env
