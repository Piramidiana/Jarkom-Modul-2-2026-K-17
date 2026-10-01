#!/bin/bash
DOMAIN="k17.com"
IP_PRAB="10.72.5.2"

cat > /etc/bind/named.conf.local << EOF
zone "$DOMAIN" {
    type slave;
    masters { $IP_PRAB; };
    file "/var/cache/bind/db.$DOMAIN";
};
zone "4.72.10.in-addr.arpa" { type slave; masters { $IP_PRAB; }; file "/var/cache/bind/db.10.72.4"; };
zone "3.72.10.in-addr.arpa" { type slave; masters { $IP_PRAB; }; file "/var/cache/bind/db.10.72.3"; };
zone "6.72.10.in-addr.arpa" { type slave; masters { $IP_PRAB; }; file "/var/cache/bind/db.10.72.6"; };
zone "7.72.10.in-addr.arpa" { type slave; masters { $IP_PRAB; }; file "/var/cache/bind/db.10.72.7"; };
EOF

# Autostart Service (No. 20)
if ! grep -q "named" /etc/network/interfaces; then
    echo "    up /usr/sbin/named -u bind" >> /etc/network/interfaces
fi

kill -9 \$(pidof named) 2>/dev/null; named -u bind
echo "[SUKSES] Tedd (Slave) siap menerima Zone Transfer!"