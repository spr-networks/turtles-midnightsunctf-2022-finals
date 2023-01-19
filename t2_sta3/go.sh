#!/bin/bash

ip addr add dev wlan5 192.168.2.3/24
wpa_supplicant -B  -Dnl80211 -iwlan5 -c /w.conf
/service.sh

