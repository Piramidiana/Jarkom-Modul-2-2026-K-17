#!/bin/sh
set -e

for config in \
  /etc/nginx/http.d/oblada.conf \
  /root/configure-oblada-nginx.sh
do
  if ! grep -q 'set_real_ip_from 10.72.3.2;' "$config"; then
    sed -i '/server_name oblada\.k17\.com/a\
    set_real_ip_from 10.72.3.2;\
    real_ip_header X-Real-IP;' "$config"
  fi

  sed -i 's@^log_format proxyproof .*@log_format proxyproof "host=$host client=$remote_addr proxy=$realip_remote_addr status=$status";@' "$config"
done

nginx -t
