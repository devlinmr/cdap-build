DOCKER_IMAGE_TAG ?= latest
DOCKER_IMAGE = devlm/cdap
ENVFILE ?= env.template

all:
	$(MAKE) build test clean

ciPush: build test push clean

envfile:
	cp -f $(ENVFILE) .env

clone: envfile
	git submodule update --remote --recursive --init

build: clone
	docker build -t ${DOCKER_IMAGE}:$(DOCKER_IMAGE_TAG) .

test:
	echo "Tests go here..."

push: envfile
	docker push ${DOCKER_IMAGE}:$(DOCKER_IMAGE_TAG)

clean:
	rm -f .env
