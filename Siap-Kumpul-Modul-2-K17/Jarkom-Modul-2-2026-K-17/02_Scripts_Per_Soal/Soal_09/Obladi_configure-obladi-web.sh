#!/bin/sh
set -e

mkdir -p /var/www/obladi/arsip

cat > /var/www/obladi/index.html <<'HTML'
<!doctype html>
<html lang="id">
<head><meta charset="utf-8"><title>Arsip Obladi</title></head>
<body>
  <h1>Repositori Statis Obladi</h1>
  <p>Arsip The Mesh dapat dibuka melalui <a href="/arsip/">/arsip/</a>.</p>
</body>
</html>
HTML

printf 'Dokumen contoh arsip dari Obladi, kelompok K-17.\n' > /var/www/obladi/arsip/catatan-obladi.txt

cat > /etc/apache2/sites-available/obladi.conf <<'APACHE'
<VirtualHost *:80>
    ServerName obladi.k17.com
    ServerAlias penny.k17.com www.k17.com vault.k17.com
    RemoteIPHeader X-Real-IP
    RemoteIPInternalProxy 10.72.4.2
    CustomLog /var/log/apache2/obladi-proxy.log "host=%{Host}i client=%a proxy=%{c}a status=%>s"
    DocumentRoot /var/www/obladi

    <Directory /var/www/obladi>
        Options FollowSymLinks
        Require all granted
    </Directory>

    <Directory /var/www/obladi/arsip>
        Options +Indexes
        Require all granted
    </Directory>
</VirtualHost>
APACHE

a2ensite obladi.conf
apache2ctl configtest
