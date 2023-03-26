#!/usr/bin/env zsh

set -Eeuo pipefail

# get platform as lower case, e.g. linux, darwin ...
# though technically it will always be linux
os=$(uname | tr '[:upper:]' '[:lower:]')
platform=$(uname -m)

if [[ "$platform" == "aarch64" ]]
then
  # aarch64 is an "alias" for arm64
  platform="arm64"
fi

latest_release_url=https://api.github.com/repos/algorand/indexer/releases/latest
download_url=$(curl -s $latest_release_url | jq -r ".assets | .[] | select(.name | test(\"${os}_${platform}\") and test(\"bz2$\")) | .browser_download_url")
curl -sL -o algorand_indexer.tar.bz2 $download_url
mkdir -p ~/indexer
tar -xf algorand_indexer.tar.bz2 --strip-components=1 -C ~/indexer
rm algorand_indexer.tar.bz2
