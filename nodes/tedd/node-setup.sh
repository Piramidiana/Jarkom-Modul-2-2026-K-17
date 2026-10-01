#!/bin/sh
NAME="$1"; IP="$2"; DOMAIN="k17.com"
[ -n "$NAME" ] && [ -n "$IP" ] || { echo "pakai: sh /root/node-setup.sh <nama> <ip>"; exit 1; }
echo "$NAME" > /etc/hostname
hostname "$NAME"
sed -i "/ $NAME\.$DOMAIN/d" /etc/hosts
echo "$IP $NAME.$DOMAIN $NAME" >> /etc/hosts
echo "[OK] hostname $NAME dipasang"
