#!/bin/bash

eval $(ssh-agent -s)
ssh-add

while true
do
  ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${NIP} "uptime;id;sleep 10;exit"
  sleep 10
done
