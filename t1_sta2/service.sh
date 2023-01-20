#!/bin/bash

while true
do
  curl -m 10 --data 'user=admin&password=four3l3phants' -X POST http://192.168.1.1/login
  sleep 10
done
