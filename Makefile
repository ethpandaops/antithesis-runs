.PHONY: config-image

# Default config file path, can be overridden
CONFIG_FILE ?= https://raw.githubusercontent.com/ethpandaops/ethereum-package/refs/heads/main/.github/tests/mix.yaml
CONFIG_IMAGE_NAME ?= ethereum-package-config
CONFIG_IMAGE_TAG ?= latest

ETHEREUM_PACKAGE_REPO ?= https://github.com/ethpandaops/ethereum-package
ETHEREUM_PACKAGE_BRANCH ?= main

config-image:
	@# Extract packages and build docker image
	@PACKAGES=$$(./scripts/extract-packages.sh -p $(ETHEREUM_PACKAGE_REPO)@$(ETHEREUM_PACKAGE_BRANCH) $(CONFIG_FILE)) && \
	docker build -f Dockerfile \
		--build-arg PACKAGE_LIST="$$PACKAGES" \
		--build-arg ETHEREUM_PACKAGE_CONFIG_FILE=$(CONFIG_FILE) \
		--build-arg ETHEREUM_PACKAGE_REPO=$(ETHEREUM_PACKAGE_REPO) \
		--build-arg ETHEREUM_PACKAGE_BRANCH=$(ETHEREUM_PACKAGE_BRANCH) \
		-t $(CONFIG_IMAGE_NAME):$(CONFIG_IMAGE_TAG) .

antithesis-images-list:
	@# Generate config images for each package
	@./scripts/extract-images.sh -f semicolon $(CONFIG_FILE)
