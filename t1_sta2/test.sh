#!/bin/bash
docker build . -t t1_sta2
docker run --rm --hostname t1_sta2 --name t1_sta2 -it --cap-add=NET_ADMIN --cap-add=NET_RAW t1_sta2
