# Makefile for building and testing the certstrap Docker image

# Repository and Git hash
REPO        := cblauvelt/certstrap
GIT_HASH    := $(shell git rev-parse --short HEAD)
TAG         := test-$(GIT_HASH)
IMAGE       := $(REPO):$(TAG)

# Base images
GO_IMAGE    := golang:latest
UBU_IMAGE   := ubuntu:24.04

# Default target: build and test
.PHONY: all
all: build test

# Build the Docker image with Git hash tag
.PHONY: build
build:
	docker build --pull \
		--build-arg BUILDER_IMAGE=$(GO_IMAGE) \
		-t $(IMAGE) .

# Run a simple test to verify certstrap and openssl
.PHONY: test
test:
	docker run --rm $(IMAGE) bash -c "\
		certstrap --version && \
		openssl version"

# Pull latest base images and rebuild
.PHONY: pull-rebuild
pull-rebuild:
	docker pull $(GO_IMAGE) && \
	docker pull $(UBU_IMAGE) && \
	$(MAKE) build

# Clean up dangling images
.PHONY: clean
clean:
	docker image rm $(IMAGE)
