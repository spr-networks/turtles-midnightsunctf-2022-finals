#!/bin/bash

ip addr add dev wlan9 192.168.3.3/24
ip addr add dev wlan10 192.168.4.2/24
wpa_supplicant -B -Dnl80211 -iwlan9 -c /w.conf
wpa_supplicant -B -Dnl80211 -iwlan10 -c /w2.conf

/etc/init.d/dbus start
/etc/init.d/avahi-daemon start

/service.sh

