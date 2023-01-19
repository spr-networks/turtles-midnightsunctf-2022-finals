#!/bin/bash
#iw reg set US

#fw forarding + masquerade rules
iptables -I FORWARD --in-interface "wlan*" --out-interface "wlan*" -j ACCEPT
iptables -t nat -I POSTROUTING -j MASQUERADE

ip addr add dev wlan8 192.168.3.1/24
hostapd -B /h.conf
