#!/bin/sh
set -e

cat > /etc/apache2/sites-available/001-penny-redirect.conf <<'APACHE'
<VirtualHost *:80>
    ServerName penny.k17.com
    Redirect permanent / http://www.k17.com/
</VirtualHost>
APACHE

a2dissite 000-default
a2ensite 001-penny-redirect
apache2ctl configtest
apache2ctl -S
