#!/bin/bash
# Aktifkan forwarding antar interface
echo 1 > /proc/sys/net/ipv4/ip_forward

# MASQUERADE: semua alamat internal 10.72.x.x keluar lewat eth0 (sisi NAT)
# -C mengecek dulu, jadi aturan tidak dobel kalau skrip dijalankan ulang
iptables -t nat -C POSTROUTING -s 10.72.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null || \
iptables -t nat -A POSTROUTING -s 10.72.0.0/16 -o eth0 -j MASQUERADE
