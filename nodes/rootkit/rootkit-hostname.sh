#!/bin/sh
echo rootkit > /etc/hostname
hostname rootkit
sed -i '/^127\.0\.1\.1/d;/ rootkit\.k17\.com/d' /etc/hosts
echo "10.72.5.1 rootkit.k17.com rootkit" >> /etc/hosts
echo "[OK] hostname rootkit dipasang"
