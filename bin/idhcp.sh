#!/bin/bash

[[ -z "$DNSSERV" ]] && DNSSERV=1.1.1.1,1.0.0.1

if [ -z "$1" ]; then
	printf "Usage:\n\t%s <LAN-if>\n\n" "$0" >&2
	exit 1
fi

LANIF="$1"

carrier_file=/sys/class/net/"$LANIF"/carrier
if [ ! -r "$carrier_file" ] || [ $(<"$carrier_file") -ne "1" ]; then
	printf "Waiting for %s link up..." "$LANIF"
	while [ ! -r "$carrier_file" ] || [ $(<"$carrier_file") -ne "1" ]; do
		sleep 0.01
	done
fi

nmcli device disconnect "$LANIF"
ip address add 192.168.42.1/24 dev "$LANIF"
dnsmasq -z -i "$LANIF" -d -C /dev/null -p 0 -F 192.168.42.2,192.168.42.2,4h -l /dev/null -O 3,192.168.42.1 -O 6,"$DNSSERV" -8 -
