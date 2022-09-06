#!/bin/bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --name mybuilder
docker buildx build --tag scjtqs/nextcloud:v24 --platform linux/amd64,linux/arm64,linux/arm/v7 --push -f Dockerfile.apache .
docker buildx rm mybuilder
