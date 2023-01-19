#!/bin/bash
#iw reg set US

rm /etc/ssh/*host*key
ssh-keygen -A
service ssh start
#fw forarding + masquerade rules
iptables -I FORWARD --in-interface "wlan*" --out-interface "wlan*" -j ACCEPT
iptables -t nat -I POSTROUTING -j MASQUERADE

APIF=$(ip link | grep wlan | awk '{print $2}' | sort | tr -d ':' | head -n 1)
CIF=$(ip link | grep wlan | awk '{print $2}' | sort | tr -d ':' | tail -n 1)
ip addr add dev $APIF $APIP/24
ip addr add dev $CIF $CIP/24
hostapd -B /h.conf

wpa_supplicant -B -Dnl80211 -i${CIF} -c /w.conf
