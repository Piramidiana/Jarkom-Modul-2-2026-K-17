#!/bin/sh
# K-17 Modul 2: aktifkan routing dan NAT ke eth0
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -C POSTROUTING -s 10.72.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null ||
  iptables -t nat -A POSTROUTING -s 10.72.0.0/16 -o eth0 -j MASQUERADE
