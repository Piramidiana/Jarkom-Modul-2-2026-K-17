#!/bin/bash
# Eksekusi di node OBLADA
echo "oblada" > /etc/hostname; hostname "oblada"
cat > /etc/hosts << EOF
127.0.0.1   localhost
127.0.1.1   oblada oblada.k17.com
EOF
rm -f /etc/resolv.conf
cat > /etc/resolv.conf << EOF
nameserver 10.72.5.2
nameserver 10.72.5.3
nameserver 192.168.122.1
EOF