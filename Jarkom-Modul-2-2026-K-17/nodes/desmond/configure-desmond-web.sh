#!/bin/sh
set -e

mkdir -p /var/www/desmond/arsip

cat > /var/www/desmond/index.html <<'HTML'
<!doctype html>
<html lang="id">
<head><meta charset="utf-8"><title>Arsip Desmond</title></head>
<body>
  <h1>Repositori Statis Desmond</h1>
  <p>Daftar arsip tersedia di <a href="/arsip/">/arsip/</a>.</p>
</body>
</html>
HTML

printf 'Dokumen contoh arsip dari Desmond, kelompok K-17.\n' > /var/www/desmond/arsip/catatan-desmond.txt

cat > /etc/apache2/sites-available/desmond.conf <<'APACHE'
<VirtualHost *:80>
    ServerName desmond.k17.com
    ServerAlias penny.k17.com www.k17.com vault.k17.com
    RemoteIPHeader X-Real-IP
    RemoteIPInternalProxy 10.72.4.2
    CustomLog /var/log/apache2/desmond-proxy.log "host=%{Host}i client=%a proxy=%{c}a status=%>s"
    DocumentRoot /var/www/desmond

    <Directory /var/www/desmond>
        Options FollowSymLinks
        Require all granted
    </Directory>

    <Directory /var/www/desmond/arsip>
        Options +Indexes
        Require all granted
    </Directory>
</VirtualHost>
APACHE

a2ensite desmond.conf
apache2ctl configtest
