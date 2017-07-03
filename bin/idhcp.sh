#!/bin/bash

DNSSERV=4.2.2.1,4.2.2.2,4.2.2.3,4.2.2.4

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

ip address add 192.168.42.1/24 dev "$LANIF"
dnsmasq -d -p 0 -F 192.168.42.2,192.168.42.2,4h -O 3,192.168.42.1 -O 6,"$DNSSERV" --dhcp-leasefile=/dev/null
