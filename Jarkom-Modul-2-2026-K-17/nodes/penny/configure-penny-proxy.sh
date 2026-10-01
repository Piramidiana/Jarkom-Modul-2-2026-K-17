#!/bin/sh
set -e

a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests slotmem_shm headers auth_basic authn_file

mkdir -p /var/www/penny/admin
cat > /var/www/penny/admin/index.html <<'HTML'
<!doctype html>
<html lang="id">
<head><meta charset="utf-8"><title>Admin Penny</title></head>
<body><h1>Ruang Admin Penny K-17</h1></body>
</html>
HTML

cat > /etc/apache2/sites-available/penny-proxy.conf <<'APACHE'
<VirtualHost *:80>
    ServerName www.k17.com
    DocumentRoot /var/www/penny

    ProxyRequests Off
    ProxyPreserveHost On
    RequestHeader set X-Real-IP "expr=%{REMOTE_ADDR}"

    <Proxy "balancer://vaultcluster">
        BalancerMember "http://10.72.5.4:80"
        BalancerMember "http://10.72.5.5:80"
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass "/eternal" "!"
    ProxyPass "/admin" "!"
    ProxyPass "/" "balancer://vaultcluster/"
    ProxyPassReverse "/" "balancer://vaultcluster/"

    <LocationMatch "^/admin(?:/|$)">
        AuthType Basic
        AuthName "Ruang Admin Penny"
        AuthUserFile /etc/apache2/auth/penny-users
        Require valid-user
    </LocationMatch>
    Alias "/eternal/" "/var/www/eternal/"
    RedirectMatch 302 "^/eternal$" "/eternal/"
    <Directory "/var/www/eternal">
        Options FollowSymLinks
        DirectoryIndex index.php
        Require all granted
    </Directory>
</VirtualHost>
APACHE

a2ensite penny-proxy
apache2ctl configtest
