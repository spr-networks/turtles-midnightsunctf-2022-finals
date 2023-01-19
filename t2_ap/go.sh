#!/bin/bash
#iw reg set US
ip addr add dev wlan4 192.168.2.1/24
hostapd -B /h.conf
