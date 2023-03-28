#!/usr/bin/env bash

set -Eeuo pipefail

releases_url=https://api.github.com/repos/algorand/go-algorand/releases
latest_tag=$(curl -s $releases_url | jq -r '[.[] | select(.target_commitish == "rel/stable") | .tag_name][0]')

# build for arm64v8
docker build --build-arg ARCH=arm64v8 --tag smonn/algo-devkit:${latest_tag}-arm64v8 .
docker push smonn/algo-devkit:${latest_tag}-arm64v8

# build for amd64
docker build --build-arg ARCH=amd64 --tag smonn/algo-devkit:${latest_tag}-amd64 .
docker push smonn/algo-devkit:${latest_tag}-amd64

# create and push manifest
docker manifest create smonn/algo-devkit:${latest_tag} \
  --amend smonn/algo-devkit:${latest_tag}-arm64v8 \
  --amend smonn/algo-devkit:${latest_tag}-amd64
docker manifest push smonn/algo-devkit:${latest_tag}

# create and push manifest
docker manifest create smonn/algo-devkit:latest \
  --amend smonn/algo-devkit:${latest_tag}-arm64v8 \
  --amend smonn/algo-devkit:${latest_tag}-amd64
docker manifest push smonn/algo-devkit:latest
