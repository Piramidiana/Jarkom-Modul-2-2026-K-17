#!/bin/bash
. /root/dns-vars.sh
echo "outbound IN CNAME http.badssl.com." >> /etc/bind/db.$DOMAIN
