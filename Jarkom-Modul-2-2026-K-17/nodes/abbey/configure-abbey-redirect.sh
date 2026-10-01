#!/bin/sh
set -e

cat > /etc/nginx/http.d/default.conf <<'NGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name abbey.k17.com;

    return 302 http://static.k17.com$request_uri;
}
NGINX

nginx -t
