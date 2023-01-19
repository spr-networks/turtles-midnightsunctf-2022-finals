#!/bin/bash
apt-get install -y docker.io docker-compose linux-modules-extra-`uname -r` iw
fallocate -l 4G /swap
chmod 0600 /swap
mkswap /swap
swapon /swap
