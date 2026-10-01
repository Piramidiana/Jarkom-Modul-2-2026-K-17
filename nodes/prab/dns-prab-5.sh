#!/bin/bash
. /root/dns-vars.sh
mkdir -p /run/named; chown bind:bind /run/named
chown -R bind:bind /var/cache/bind; chown bind:bind /etc/bind/db.*
named-checkconf || exit 1
named-checkzone $DOMAIN /etc/bind/db.$DOMAIN || exit 1
for n in 3 4 5; do named-checkzone $n.72.10.in-addr.arpa /etc/bind/db.10.72.$n || exit 1; done
service named stop 2>/dev/null; pkill named 2>/dev/null; sleep 1
service named start || named -u bind -c /etc/bind/named.conf
sleep 2
if [ -n "$(dig @127.0.0.1 $DOMAIN SOA +short)" ]; then
 printf 'nameserver 10.72.5.2\nnameserver 10.72.5.3\nnameserver 192.168.122.1\n' > /etc/resolv.conf
 echo "[OK] named menjawab"
else echo "[X] named tidak menjawab"; fi
