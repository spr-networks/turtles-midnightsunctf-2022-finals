#!/bin/bash

IP="192.168.2.4"

while true; do
	/telnet-cli.expect $IP root tpowah "id;exit"
	wpa_cli reassociate
	sleep 30
done

