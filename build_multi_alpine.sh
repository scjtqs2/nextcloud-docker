#!/bin/bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --name mybuilder2
docker buildx build --tag scjtqs/nextcloud:v24-fpm-alpine --platform linux/amd64,linux/arm64,linux/arm/v7  --push -f Dockerfile.fpm.alpine .
docker buildx rm mybuilder2
