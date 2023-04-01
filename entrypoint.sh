#!/usr/bin/env sh

set -e
sudo chown root:docker /var/run/docker.sock
sudo chmod 666 /var/run/docker.sock
