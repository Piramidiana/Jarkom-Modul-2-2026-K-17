#!/bin/sh
ip addr show dev eth0 | grep -q '10.72.5.3/24' || ip addr add '10.72.5.3/24' dev eth0
ip link set eth0 up
ip route replace default via '10.72.5.1' dev eth0
printf 'nameserver 192.168.122.1\n' > /etc/resolv.conf
