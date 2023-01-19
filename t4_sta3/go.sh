#!/bin/bash

CIF=$(ip link | grep wlan | awk '{print $2}' | sort | tr -d ':' | tail -n 1)
ip route del default
ip addr add dev wlan12 192.168.4.3/24
ip route add default via 192.168.4.1

wpa_supplicant -B  -Dnl80211 -iwlan12 -c /w.conf

/etc/init.d/dbus start
/etc/init.d/avahi-daemon start

/service.sh

