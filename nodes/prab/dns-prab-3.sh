#!/bin/bash
. /root/dns-vars.sh
cat > /etc/bind/db.$DOMAIN << EOT
\$TTL 86400
@ IN SOA prab.$DOMAIN. admin.$DOMAIN. ( $SERIAL 3600 900 604800 86400 )
@ IN NS prab.$DOMAIN.
@ IN NS tedd.$DOMAIN.
@ IN A 10.72.4.2
prab IN A 10.72.5.2
tedd IN A 10.72.5.3
rootkit IN A 10.72.5.1
alpha IN A 10.72.1.2
beta IN A 10.72.1.3
gamma IN A 10.72.1.4
delta IN A 10.72.2.2
epsilon IN A 10.72.2.3
abbey IN A 10.72.3.2
penny IN A 10.72.4.2
obladi IN A 10.72.5.4
desmond IN A 10.72.5.5
oblada IN A 10.72.5.6
molly IN A 10.72.5.7
EOT
