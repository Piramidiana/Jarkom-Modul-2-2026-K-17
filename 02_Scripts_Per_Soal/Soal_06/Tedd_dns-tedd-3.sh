#!/bin/bash
mkdir -p /run/named; chown bind:bind /run/named
chown -R bind:bind /var/cache/bind
named-checkconf || exit 1
service named stop 2>/dev/null; pkill named 2>/dev/null; sleep 1
service named start || named -u bind -c /etc/bind/named.conf
sleep 3
for z in k17.com 3.72.10.in-addr.arpa 4.72.10.in-addr.arpa 5.72.10.in-addr.arpa; do
 rndc retransfer $z
done
sleep 3
if [ -n "$(dig @127.0.0.1 k17.com SOA +short)" ]; then
 printf 'nameserver 10.72.5.2\nnameserver 10.72.5.3\nnameserver 192.168.122.1\n' > /etc/resolv.conf
 echo "[OK] tedd menjawab"
else echo "[X] tedd belum menjawab, zona belum tertarik"; fi
