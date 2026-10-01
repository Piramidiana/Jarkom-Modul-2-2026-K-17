#!/bin/bash
ip addr show dev eth0 | grep -q '10.72.5.3/24' || ip addr add 10.72.5.3/24 dev eth0
ip link set eth0 up
ip route replace default via 10.72.5.1 dev eth0
printf 'nameserver 192.168.122.1\n' > /etc/resolv.conf
ping -c 2 -W 3 8.8.8.8 >/dev/null || { echo "[X] tidak ada internet, cek NAT rootkit"; exit 1; }
apt-get update
apt-get install -y bind9 bind9-utils bind9-dnsutils
cat > /etc/bind/named.conf.options << EOT
options {
 directory "/var/cache/bind";
 forwarders { 192.168.122.1; };
 dnssec-validation no;
 listen-on { any; };
 listen-on-v6 { none; };
 allow-query { any; };
 recursion yes;
 allow-recursion { 10.72.0.0/16; 127.0.0.1; };
};
EOT
