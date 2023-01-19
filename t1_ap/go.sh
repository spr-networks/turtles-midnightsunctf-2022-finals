#!/bin/bash
#iw reg set US

rm /etc/ssh/*host*key
ssh-keygen -A
service ssh start

ip addr add dev wlan0 192.168.1.1/24
ip addr add dev wlan3 192.168.2.2/24

hostapd -B /h.conf

wpa_supplicant -B -Dnl80211 -iwlan3 -c /w.conf 

node /app/index.js
