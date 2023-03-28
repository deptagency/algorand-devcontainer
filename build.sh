#!/usr/bin/env bash

set -Eeuo pipefail

releases_url=https://api.github.com/repos/algorand/go-algorand/releases
latest_tag=$(curl -s $releases_url | jq -r '[.[] | select(.target_commitish == "rel/stable") | .tag_name][0]')
base_name=ghcr.io/smonn/algo-devkit

# build for arm64v8
docker build --build-arg ARCH=arm64v8 --tag ${base_name}:${latest_tag}-arm64v8 .
docker push ${base_name}:${latest_tag}-arm64v8

# build for amd64
docker build --build-arg ARCH=amd64 --tag ${base_name}:${latest_tag}-amd64 .
docker push ${base_name}:${latest_tag}-amd64

# create and push manifest
docker manifest create ${base_name}:${latest_tag} \
  --amend ${base_name}:${latest_tag}-arm64v8 \
  --amend ${base_name}:${latest_tag}-amd64
docker manifest push ${base_name}:${latest_tag}

# create and push manifest
docker manifest create ${base_name}:latest \
  --amend ${base_name}:${latest_tag}-arm64v8 \
  --amend ${base_name}:${latest_tag}-amd64
docker manifest push ${base_name}:latest
