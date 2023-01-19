#!/bin/bash
apt-get install -y docker.io docker-compose linux-modules-extra-`uname -r` iwatch iw
fallocate -l 8G /swap
chmod 0600 /swap
mkswap /swap
swapon /swap
