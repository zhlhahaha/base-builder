IMAGE=imega/base-builder
TAG=latest
ARCH=$(shell uname -m)

ifeq ($(ARCH),x86_64)
	ARCH=amd64
endif

build:
	@docker build -t $(IMAGE):$(TAG)-$(ARCH) .

login:
	@docker login --username $(DOCKER_USER) --password $(DOCKER_PASS)

release: login build
	docker tag $(IMAGE):$(TAG)-$(ARCH) $(IMAGE):latest-$(ARCH)
	docker push $(IMAGE):$(TAG)-$(ARCH)
	docker push $(IMAGE):latest-$(ARCH)

release-manifest: login
	@docker manifest create $(IMAGE):$(TAG) $(IMAGE):$(TAG)-amd64 $(IMAGE):$(TAG)-ppc64le
	@docker manifest create $(IMAGE):latest $(IMAGE):latest-amd64 $(IMAGE):latest-ppc64le
	@docker manifest push $(IMAGE):$(TAG)
	@docker manifest push $(IMAGE):latest

test: build
	$(MAKE) test -C tests IMAGE=$(IMAGE) TAG=$(TAG)
