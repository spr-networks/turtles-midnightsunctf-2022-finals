#!/bin/bash

#check AP uptime
ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@192.168.4.1 "uptime;exit"

while true
do
  /mdns-client
done
