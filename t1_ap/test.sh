#!/bin/bash
docker build . -t t1_ap
docker run --hostname t1_ap --rm --name t1_ap -it --cap-add=NET_ADMIN --cap-add=NET_RAW t1_ap
