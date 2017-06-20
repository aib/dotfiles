#!/bin/bash

if [ -z "$1" ]; then
	printf "Usage:\n\t%s <LAN-if>\n\n" "$0" >&2
	exit 1
fi

DNSSERV=130.255.78.223,130.255.73.90,62.113.203.99,172.104.136.243 #OpenNIC

ip address add 192.168.42.1/24 dev $1
dnsmasq -d -p 0 -F 192.168.42.2,192.168.42.2,4h -O 3,192.168.42.1 -O 6,${DNSSERV} --dhcp-leasefile=/dev/null
