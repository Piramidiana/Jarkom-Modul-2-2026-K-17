#!/bin/sh
set -e

cat > /etc/nginx/http.d/oblada.conf <<'NGINX'
log_format proxyproof "host=$host client=$remote_addr proxy=$realip_remote_addr status=$status";
server {
    listen 80;
    server_name oblada.k17.com core.k17.com abbey.k17.com static.k17.com;
    set_real_ip_from 10.72.3.2;
    real_ip_header X-Real-IP;
    access_log /var/log/nginx/oblada-proxy.log proxyproof;
    root /var/www/oblada;
    index index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location = /profil {
        rewrite ^ /profil.php last;
    }

    location ~ \.php$ {
        try_files $uri =404;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass 127.0.0.1:9000;
    }
}
NGINX

nginx -t
