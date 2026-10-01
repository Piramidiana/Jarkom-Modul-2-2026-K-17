#!/bin/bash
. /root/dns-vars.sh
cat >> /etc/bind/db.$DOMAIN << EOT
vault IN A 10.72.5.4
vault IN A 10.72.5.5
core IN A 10.72.5.6
core IN A 10.72.5.7
www IN CNAME penny.$DOMAIN.
static IN CNAME abbey.$DOMAIN.
EOT
hdr() { printf '$TTL 86400\n@ IN SOA prab.%s. admin.%s. ( %s 3600 900 604800 86400 )\n@ IN NS prab.%s.\n@ IN NS tedd.%s.\n' $DOMAIN $DOMAIN $SERIAL $DOMAIN $DOMAIN; }
{ hdr; echo "2 IN PTR abbey.$DOMAIN."; } > /etc/bind/db.10.72.3
{ hdr; echo "2 IN PTR penny.$DOMAIN."; } > /etc/bind/db.10.72.4
{ hdr; for x in "2 prab" "3 tedd" "4 vault" "5 vault" "6 core" "7 core"; do set -- $x; echo "$1 IN PTR $2.$DOMAIN."; done; } > /etc/bind/db.10.72.5
