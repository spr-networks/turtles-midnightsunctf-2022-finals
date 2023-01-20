#!/bin/bash

redis-server --daemonize yes
redis-cli CONFIG SET protected-mode no

# mdns-publish exits after 10s

# mdns-client will try to connect to this ip on port 2323 - see code/mdns-publish.c
#while true; do
#	/mdns-publish
#	sleep 10
#done

