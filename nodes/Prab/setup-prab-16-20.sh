#!/bin/bash
# No. 17: TXT Record
cat >> /etc/bind/db.k17.com << 'EOF'
alpha   IN  TXT "alpha"
beta    IN  TXT "beta"
gamma   IN  TXT "gamma"
delta   IN  TXT "delta"
epsilon IN  TXT "epsilon"
outbound IN CNAME http.badssl.com.
EOF

# Update serial SOA
sed -i 's/2026100501/2026100502/g' /etc/bind/db.k17.com
kill -9 $(pidof named) 2>/dev/null; named -u bind

# No. 20: Auto-start service di interfaces
if ! grep -q "named" /etc/network/interfaces; then
    echo "    up /usr/sbin/named -u bind" >> /etc/network/interfaces
fi