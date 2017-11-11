IMAGE=imega/base-builder
TAG=latest

build:
	@docker build -t $(IMAGE):$(TAG) .

release: build
	@docker login --username $(DOCKER_USER) --password $(DOCKER_PASS)
	@docker push $(IMAGE):$(TAG)
