#!/bin/bash
PRAB_IP="10.72.5.2"
{
cat << EOT
zone "k17.com" {
 type secondary; primaries { $PRAB_IP; }; file "/var/cache/bind/db.k17.com";
};
EOT
for n in 3 4 5; do
cat << EOT
zone "$n.72.10.in-addr.arpa" {
 type secondary; primaries { $PRAB_IP; }; file "/var/cache/bind/db.10.72.$n";
};
EOT
done
} > /etc/bind/named.conf.local
