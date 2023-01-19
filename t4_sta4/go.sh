#!/bin/bash

CIF=$(ip link | grep wlan | awk '{print $2}' | tr -d ':' | tail -n 1)
ip route del default
ip addr add dev ${CIF} $DIP/24

wpa_supplicant -B  -Dnl80211 -i${CIF} -c /w.conf

ip route add default via ${CIP}
/service.sh

