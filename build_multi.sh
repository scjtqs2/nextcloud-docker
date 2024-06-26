#!/bin/bash
#docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --name mybuilder
docker buildx build --tag scjtqs/nextcloud:latest --platform linux/amd64,linux/arm64,linux/arm/v7  --push  .
# docker buildx build --tag registry.cn-hangzhou.aliyuncs.com/scjtqs/nextcloud:latest --platform linux/amd64,linux/arm64,linux/arm/v7  --push .
docker buildx rm mybuilder
