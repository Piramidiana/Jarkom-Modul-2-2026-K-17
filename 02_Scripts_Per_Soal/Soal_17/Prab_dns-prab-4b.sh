#!/bin/bash
. /root/dns-vars.sh
for n in alpha beta gamma delta epsilon; do
 echo "$n IN TXT \"$n\"" >> /etc/bind/db.$DOMAIN
done
