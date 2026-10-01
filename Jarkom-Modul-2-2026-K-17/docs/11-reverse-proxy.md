# Nomor 11 — Reverse proxy The Mesh (K-17)

## Penny → area vault (selesai diuji)

Penny `10.72.4.2` menjalankan Apache 2.4.68 di Debian 13. Sebelum instalasi, Penny dapat mengakses `http://obladi.k17.com/arsip/` dan `http://desmond.k17.com/arsip/` (keduanya HTTP 200) serta internet. Skrip instalasi: `/root/install-penny-apache.sh` (`apt-get update`, `apt-get install -y apache2`). Apache di container dijalankan manual `apache2ctl -k start` karena kebijakan init mencegah start otomatis.

Modul yang diaktifkan melalui `a2enmod`: `proxy proxy_http proxy_balancer lbmethod_byrequests slotmem_shm headers`. Skrip `/root/configure-penny-proxy.sh` menyalakan modul tersebut, menulis `/etc/apache2/sites-available/penny-proxy.conf`, menjalankan `a2ensite penny-proxy` dan `apache2ctl configtest` (`Syntax OK`). Isi virtual host:

```apache
<VirtualHost *:80>
    ServerName penny.k17.com
    ServerAlias www.k17.com
    ProxyRequests Off
    ProxyPreserveHost On
    RequestHeader set X-Real-IP "expr=%{REMOTE_ADDR}"
    <Proxy "balancer://vaultcluster">
        BalancerMember "http://10.72.5.4:80"
        BalancerMember "http://10.72.5.5:80"
        ProxySet lbmethod=byrequests
    </Proxy>
    ProxyPass "/" "balancer://vaultcluster/"
    ProxyPassReverse "/" "balancer://vaultcluster/"
</VirtualHost>
```

Pada Obladi dan Desmond, vhost dan skrip konfigurasi masing-masing ditambah `ServerAlias penny.k17.com www.k17.com vault.k17.com` agar permintaan dengan header `Host` asli memilih situs yang benar. `apache2ctl configtest` dan graceful reload pada keduanya sukses.

Untuk membuktikan identitas pengunjung, vhost dan skrip konfigurasi Obladi ditambah:

```apache
CustomLog /var/log/apache2/obladi-proxy.log "host=%{Host}i real=%{X-Real-IP}i peer=%a status=%>s"
```

Desmond memakai format sama pada `/var/log/apache2/desmond-proxy.log`. Setelah reload kedua backend, Alpha (`10.72.1.2`) mengakses `http://penny.k17.com/` empat kali. DNS Penny menjawab `10.72.4.2`; isi respons bergantian `Repositori Statis Obladi`, `Repositori Statis Desmond`, `Obladi`, `Desmond`. Log pada kedua backend menunjukkan `host=penny.k17.com real=10.72.1.2 peer=10.72.4.2 status=200`. Jadi header Host dan X-Real-IP tiba dan trafik dibagikan ke dua server.

Screenshot bukti telah diterima dan diperiksa: `assets/11-penny-proxy-evidence.png` menggabungkan terminal Alpha (DNS dan empat jawaban bergantian) dengan log Obladi dan Desmond (Host, IP asli Alpha, peer Penny, status 200). Satu gambar ini cukup untuk bagian Penny.

## Abbey → area core (selesai diuji)

Abbey `10.72.3.2` menjalankan Alpine 3.23.5. Sebelum instalasi, Abbey dapat mengakses Oblada dan Molly melalui hostname (`Dilayani oleh: oblada` dan `molly`), ping internet 2/2, dan `apk update` sukses. Skrip `/root/install-abbey-nginx.sh` memasang Nginx 1.28.3-r7.

Kedua backend Nginx (`/etc/nginx/http.d/oblada.conf` dan `molly.conf` beserta skrip setup masing-masing) menambahkan `abbey.k17.com static.k17.com` dalam `server_name`, kemudian lulus `nginx -t` dan reload. Dengan begitu backend memilih virtual host yang benar ketika Abbey mempertahankan `Host` asli.

Skrip `/root/configure-abbey-proxy.sh` membuat `/etc/nginx/http.d/abbey-proxy.conf` dan menjalankan `nginx -t` (berhasil):

```nginx
upstream core_nodes {
    server 10.72.5.6:80;
    server 10.72.5.7:80;
}

server {
    listen 80;
    server_name abbey.k17.com static.k17.com;
    location / {
        proxy_pass http://core_nodes;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

`nginx` dijalankan manual. Pengujian dari Alpha: `abbey.k17.com` menjawab `10.72.3.2`, enam permintaan `http://abbey.k17.com/profil` seluruhnya HTTP 200 dan bergantian `molly`, `oblada`, `molly`, `oblada`, `molly`, `oblada`. Uji setelah reload logging: empat respons `molly`, `oblada`, `molly`, `oblada`.

Pada kedua backend, vhost dan skrip konfigurasinya ditambah log khusus dengan format di level `http`:

```nginx
log_format proxyproof "host=$host real=$http_x_real_ip peer=$remote_addr status=$status";
```

Di server Oblada `access_log /var/log/nginx/oblada-proxy.log proxyproof;`; di Molly `access_log /var/log/nginx/molly-proxy.log proxyproof;`. Setelah `nginx -t` dan reload berhasil, log kedua node mencatat `host=abbey.k17.com real=10.72.1.2 peer=10.72.3.2 status=200`. Ini membuktikan header Host dan X-Real-IP diteruskan dari Abbey dengan IP asli klien Alpha.

Screenshot laporan diterima dan diperiksa: `assets/11-abbey-proxy-evidence.png` menampilkan terminal Alpha (DNS, HTTP 200 dan respons bergantian) serta log Oblada dan Molly (Host, IP asli Alpha, peer Abbey, status 200). Bagian nomor 11 selesai pada kedua gerbang; autostart menunggu nomor 20.

## Uji ulang setelah restart

Autostart Apache/Nginx dan pemulihan rute/DNS pada node akan diperiksa bersama pada nomor 20. Konfigurasi tersimpan dalam skrip, tetapi layanan setelah restart belum diuji.
