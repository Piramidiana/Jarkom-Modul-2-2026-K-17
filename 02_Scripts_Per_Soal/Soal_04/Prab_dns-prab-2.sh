#!/bin/bash
. /root/dns-vars.sh
{
cat << EOT
zone "$DOMAIN" {
 type master; file "/etc/bind/db.$DOMAIN";
 notify yes; also-notify { $TEDD_IP; }; allow-transfer { $TEDD_IP; };
};
EOT
for n in 3 4 5; do
cat << EOT
zone "$n.72.10.in-addr.arpa" {
 type master; file "/etc/bind/db.10.72.$n";
 notify yes; also-notify { $TEDD_IP; }; allow-transfer { $TEDD_IP; };
};
EOT
done
} > /etc/bind/named.conf.local
