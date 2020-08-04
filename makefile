# Define apps and registry
REGISTRY_PREFIX ?=
REGISTRY 		?=$(REGISTRY_PREFIX).azurecr.io
IMAGE_NAME		?=tf-1.12.0-gpu
IMAGE_VERSION	?=

# Docker image build and push setting
DOCKERFILE:=

# build
.PHONY: build
build: build-image clean-dangling

.PHONY: build-image
build-image:
	docker build -f $(DOCKERFILE) . -t $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_VERSION)

# clean dangling
clean-dangling:
	$(eval DANGLING_IMAGES := $(shell docker images -f 'dangling=true' -q))
	$(if $(DANGLING_IMAGES),docker rmi --force $(DANGLING_IMAGES),)

# push
.PHONY: push
push:
	docker push $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_VERSION)

# option 1
.PHONY: option1
option1: set-option1 build push
set-option1:
    $(eval IMAGE_VERSION := option1)
    $(eval DOCKERFILE := $(IMAGE_VERSION)-Dockerfile)

# option 2
.PHONY: option2
option2: set-option2 build push
set-option2:
    $(eval IMAGE_VERSION := option2)
    $(eval DOCKERFILE := $(IMAGE_VERSION)-Dockerfile)