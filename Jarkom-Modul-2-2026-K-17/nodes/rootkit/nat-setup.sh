#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -o eth0 -j ACCEPT
