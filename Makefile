DOCKER_IMAGE_NAME = oslbuild/consul

build:
	docker build -t $(DOCKER_IMAGE_NAME):latest .

test-run: build
	docker run -it --rm --name consul -p 8500:8500 oslbuild/consul consul agent -dev
