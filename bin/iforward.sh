#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
	printf "Usage:\n\t%s <LAN-if> <WAN-if>\n\n" "$0" >&2
	exit 1
fi

LANIF="$1"
WANIF="$2"

sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o "$WANIF" -j MASQUERADE
iptables -A FORWARD -i "$WANIF" -o "$LANIF" -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i "$LANIF" -o "$WANIF" -j ACCEPT
