#!/bin/bash

# 定义一个数组来保存没有匹配的标签
no_match_tags=()
while read -r latest; do
    HAVE_TAG=false
    for tag in $(git tag); do
        if [ "${latest}" == "${tag}" ]; then
            HAVE_TAG=true
        fi
    done
    if ! ${HAVE_TAG}; then
        git tag ${latest}
        echo ${latest}
        no_match_tags+=("${latest}")
    fi
done < latest


# 构建缺失的标签镜像
for LATEST in "${no_match_tags[@]}"; do
    echo "Processing tag: ${LATEST}"
    echo $LATEST >> version
    rm -f ./Dockerfile && rm -f ./Dockerfile.fpm.alpine
    cp -f Dockerfile.template Dockerfile
    sed -i "s/%%VARIANT%%/${LATEST}/g" Dockerfile
    cp -f Dockerfile.fpm.alpine.template Dockerfile.fpm.alpine
    sed -i "s/%%VARIANT%%/${LATEST}/g" Dockerfile.fpm.alpine
    docker buildx create --use --name mybuilder
    docker buildx build --tag scjtqs/nextcloud:${LATEST} --platform linux/amd64,linux/arm64,linux/arm/v7  --push  .
    docker buildx build --tag scjtqs/nextcloud:${LATEST}-alpine --platform linux/amd64,linux/arm64,linux/arm/v7  --push -f Dockerfile.fpm.alpine .
    docker buildx rm mybuilder

    git add latest
    git add version
    git config --local user.email ${MAIL}
    git config --local user.name ${MY_NAME}
    git commit -a -m "build version ${LATEST}"

done
