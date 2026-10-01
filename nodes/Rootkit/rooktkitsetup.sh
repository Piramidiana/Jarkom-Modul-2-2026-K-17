#!/bin/bash
# Eksekusi di node ROOTKIT
echo "rootkit" > /etc/hostname
hostname "rootkit"
cat > /etc/hosts << EOF
127.0.0.1   localhost
127.0.1.1   rootkit rootkit.k17.com
EOF
echo "[SUKSES] Hostname Rootkit selesai diatur!"