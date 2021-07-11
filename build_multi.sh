#!/bin/bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --name mybuilder191
docker buildx build --tag scjtqs/nextcloud:v19-latest --platform linux/amd64,linux/arm64,linux/arm/v6,linux/386,linux/ppc64le --push .
docker buildx build --tag registry.cn-hangzhou.aliyuncs.com/scjtqs/nextcloud:v19-latest --platform linux/amd64,linux/arm64,linux/arm/v6,linux/386,linux/ppc64le --push .
docker buildx rm mybuilder191
