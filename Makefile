IMAGE=imega/base-builder
TAG=latest

build:
	@docker build -t $(IMAGE):$(TAG) .

release: build
	@docker login --username $(DOCKER_USER) --password $(DOCKER_PASS)
	@docker tag $(IMAGE):$(TAG) $(IMAGE):latest
	@docker push $(IMAGE):$(TAG)
	@docker push $(IMAGE):latest


test: build
	$(MAKE) test -C tests
