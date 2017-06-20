#!/bin/bash

if [ -z "$1" -o -z "$2" ]; then
	printf "Usage:\n\t%s <LAN-if> <WAN-if>\n\n" "$0" >&2
	exit 1
fi

sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE
iptables -A FORWARD -i $2 -o $1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $1 -o $2 -j ACCEPT
