#!/bin/bash

while true
do
  sleep 600
  kill -9 $(ps -A -ostat,ppid | grep -e '[zZ]'| awk '{ print $2 }')
done
