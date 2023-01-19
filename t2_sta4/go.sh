#!/bin/bash

ip addr add dev wlan6 192.168.2.4/24
ip addr add dev wlan7 192.168.3.2/24
wpa_supplicant -B -Dnl80211 -iwlan6 -c /w.conf
wpa_supplicant -B -Dnl80211 -iwlan7 -c /w2.conf

# start telnetd, TODO expose 23
inetd

/service.sh

