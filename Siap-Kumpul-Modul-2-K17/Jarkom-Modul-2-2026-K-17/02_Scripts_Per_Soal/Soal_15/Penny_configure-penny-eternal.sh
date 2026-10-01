#!/bin/sh
set -e

for config in \
  /etc/apache2/sites-available/penny-proxy.conf \
  /root/configure-penny-proxy.sh
do
  grep -q 'ProxyPass "/eternal" "!"' "$config" ||
    sed -i '/ProxyPass "\/admin" "!"/i\    ProxyPass "/eternal" "!"' "$config"

  grep -q 'Alias "/eternal/"' "$config" ||
    sed -i '/^<\/VirtualHost>$/i\
    Alias "/eternal/" "/var/www/eternal/"\
    RedirectMatch 302 "^/eternal$" "/eternal/"\
    <Directory "/var/www/eternal">\
        Options FollowSymLinks\
        DirectoryIndex index.php\
        Require all granted\
    </Directory>' "$config"
done

apache2ctl configtest
