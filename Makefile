IMAGE=murilofv/base-builder
TAG=latest
ARCH=$(shell uname -m)

ifeq ($(ARCH),x86_64)
	ARCH=amd64
endif

build:
	echo $(ARCH)
	@docker build -t $(IMAGE):$(TAG)-$(ARCH) .

release: build
	@docker login --username $(DOCKER_USER) --password $(DOCKER_PASS)
	@docker tag $(IMAGE):$(TAG)-$(ARCH) $(IMAGE):latest-$(ARCH)
	@docker push $(IMAGE):$(TAG)-$(ARCH)
	@docker push $(IMAGE):latest-$(ARCH)

release-manifest:
	@docker login --username $(DOCKER_USER) --password $(DOCKER_PASS)
	@docker manifest create $(IMAGE):$(TAG) $(IMAGE):$(TAG)-amd64 $(IMAGE):$(TAG)-ppc64le
	@docker manifest create $(IMAGE):latest $(IMAGE):latest-amd64 $(IMAGE):latest-ppc64le
	@docker manifest push $(IMAGE):$(TAG)
	@docker manifest push $(IMAGE):latest

test: build
	$(MAKE) test -C tests IMAGE=$(IMAGE) TAG=$(TAG)
