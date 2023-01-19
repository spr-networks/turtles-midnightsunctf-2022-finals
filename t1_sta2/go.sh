#!/bin/bash

ip addr add dev wlan1 192.168.1.2/24
wpa_supplicant  -B -Dnl80211 -iwlan1 -c /w.conf
/service.sh

