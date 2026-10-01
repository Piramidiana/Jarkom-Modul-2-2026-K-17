#!/bin/sh
set -e

a2enmod remoteip

for config in \
  /etc/apache2/sites-available/desmond.conf \
  /root/configure-desmond-web.sh
do
  if ! grep -q 'RemoteIPInternalProxy 10.72.4.2' "$config"; then
    sed -i '/ServerAlias penny\.k17\.com/a\
    RemoteIPHeader X-Real-IP\
    RemoteIPInternalProxy 10.72.4.2' "$config"
  fi

  sed -i 's@CustomLog /var/log/apache2/desmond-proxy.log .*@CustomLog /var/log/apache2/desmond-proxy.log "host=%{Host}i client=%a proxy=%{c}a status=%>s"@' "$config"
done

apache2ctl configtest
