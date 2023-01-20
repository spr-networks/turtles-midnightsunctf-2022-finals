#!/bin/bash
docker build . -t t1_attacker
docker run --rm --hostname t1_attacker --name t1_attacker -it --cap-add=NET_ADMIN --cap-add=NET_RAW t1_attacker
