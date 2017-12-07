build: build-fs
	@docker build -t imega/tidy .

build-fs:
	@docker run --rm=false \
		-v $(CURDIR)/build:/build \
		imega/base-builder \
		--packages="tidyhtml"

test: build
	echo "<hTmL></hTmL>" | docker run --rm=false -i imega/tidy -xml -iqu

.PHONY: build
