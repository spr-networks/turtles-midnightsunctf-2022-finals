#!/bin/bash
rm /etc/ssh/*host*key
ssh-keygen -A
service ssh start

