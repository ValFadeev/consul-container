DOCKER_IMAGE_NAME = beyondrepair/consul-container

build:
	docker build -t $(DOCKER_IMAGE_NAME):latest .

upload:
	docker push $(DOCKER_IMAGE_NAME):latest

test-run: build
	docker run -it --rm --name consul -p 8500:8500 beyondrepair/consul-container
