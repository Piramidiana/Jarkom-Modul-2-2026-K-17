#!/bin/sh
# K-17 Modul 2: alamat router dan jalur keluar
ip addr show dev eth0 | grep -q '192.168.122.10/24' || ip addr add 192.168.122.10/24 dev eth0
ip addr show dev eth1 | grep -q '10.72.1.1/24' || ip addr add 10.72.1.1/24 dev eth1
ip addr show dev eth2 | grep -q '10.72.2.1/24' || ip addr add 10.72.2.1/24 dev eth2
ip addr show dev eth3 | grep -q '10.72.3.1/24' || ip addr add 10.72.3.1/24 dev eth3
ip addr show dev eth4 | grep -q '10.72.4.1/24' || ip addr add 10.72.4.1/24 dev eth4
ip addr show dev eth5 | grep -q '10.72.5.1/24' || ip addr add 10.72.5.1/24 dev eth5
ip route replace default via 192.168.122.1 dev eth0
