#!/bin/sh
DOMAIN="k17.com"
IP=$(ip -4 addr show dev eth0 | grep -o 'inet [0-9.]*' | head -n1 | cut -d' ' -f2)
case "$IP" in
 10.72.1.2) N=alpha;   GW=10.72.1.1;;
 10.72.1.3) N=beta;    GW=10.72.1.1;;
 10.72.1.4) N=gamma;   GW=10.72.1.1;;
 10.72.2.2) N=delta;   GW=10.72.2.1;;
 10.72.2.3) N=epsilon; GW=10.72.2.1;;
 10.72.3.2) N=abbey;   GW=10.72.3.1;;
 10.72.4.2) N=penny;   GW=10.72.4.1;;
 10.72.5.2) N=prab;    GW=10.72.5.1;;
 10.72.5.3) N=tedd;    GW=10.72.5.1;;
 10.72.5.4) N=obladi;  GW=10.72.5.1;;
 10.72.5.5) N=desmond; GW=10.72.5.1;;
 10.72.5.6) N=oblada;  GW=10.72.5.1;;
 10.72.5.7) N=molly;   GW=10.72.5.1;;
 *) echo "[X] IP eth0 tidak dikenal: '$IP' (router atau salah node), dibatalkan"; exit 1;;
esac
ip route replace default via "$GW" dev eth0
printf 'nameserver 10.72.5.2\nnameserver 10.72.5.3\nnameserver 192.168.122.1\n' > /etc/resolv.conf
echo "$N" > /etc/hostname
hostname "$N"
sed -i "/ $N\.$DOMAIN/d" /etc/hosts
echo "$IP $N.$DOMAIN $N" >> /etc/hosts
echo "[OK] $N $IP gateway $GW"
