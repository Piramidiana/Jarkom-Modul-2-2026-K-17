#!/bin/sh
set -e

cat > /etc/nginx/http.d/abbey-proxy.conf <<'NGINX'
upstream core_nodes {
    server 10.72.5.6:80;
    server 10.72.5.7:80;
}

server {
    listen 80;
    server_name static.k17.com;

    location = /orion {
        return 302 /orion/;
    }

    location ~* ^/orion/.*\.php$ {
        return 403;
    }

    location /orion/ {
        alias /var/www/orion/;
        index index.html;
    }

    location / {
        proxy_pass http://core_nodes;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
NGINX

nginx -t
