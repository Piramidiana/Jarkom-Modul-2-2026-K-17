# Nomor 10 — Web dinamis area core (K-17)

Domain aktif: `k17.com`. Oblada `10.72.5.6`; Molly `10.72.5.7`. Kedua node sudah diuji dari Alpha melalui hostname.

## Oblada

- OS Alpine Linux 3.23.5; `eth0=10.72.5.6/24`; default gateway `10.72.5.1`.
- Resolver: `10.72.5.2`, `10.72.5.3`, `192.168.122.1`.
- Ping `8.8.8.8` berhasil 2/2; `nslookup dl-cdn.alpinelinux.org` berhasil; `apk update` menghasilkan 27631 paket tersedia.
- `/root/install-oblada-dynamic.sh`: `#!/bin/sh`, `set -e`, `apk add nginx php84 php84-fpm`. Terpasang Nginx 1.28.3-r7 dan PHP 8.4.21-r0.
- `/root/create-oblada-pages.sh`: membuat `/var/www/oblada/index.php` (judul `Beranda Core`) dan `/var/www/oblada/profil.php` (judul `Profil Core`). Keduanya menampilkan node memakai `htmlspecialchars(gethostname(), ENT_QUOTES, 'UTF-8')`. Perintah `php84 -l` pada kedua berkas berhasil.
- PHP-FPM pool `/etc/php84/php-fpm.d/www.conf` memakai `listen = 127.0.0.1:9000`. `php-fpm84 -t` berhasil dan daemon dijalankan dengan `php-fpm84 -D`.
- `/root/configure-oblada-nginx.sh` membuat `/etc/nginx/http.d/oblada.conf` berikut dan menjalankan `nginx -t` (berhasil). Daemon dijalankan dengan `nginx`.

```nginx
server {
    listen 80;
    server_name oblada.k17.com core.k17.com;
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
```

`rewrite` mengubah permintaan `/profil` menjadi `/profil.php` di dalam Nginx; browser tetap melihat URL bersih. `fastcgi_pass` meneruskan eksekusi PHP ke PHP-FPM pada node yang sama.

**Bukti:** dari Alpha, `getent ahostsv4 oblada.k17.com` menghasilkan `10.72.5.6`. `curl -i http://oblada.k17.com/` dan `curl -i http://oblada.k17.com/profil` keduanya HTTP 200, masing-masing menampilkan `Beranda Core` dan `Profil Core`, serta `Dilayani oleh: oblada`. Screenshot akhir nomor 10 menunggu Molly lolos uji.

## Molly

- OS Alpine Linux 3.23.5; `eth0=10.72.5.7/24`, gateway `10.72.5.1`; resolver Prab `10.72.5.2`, Tedd `10.72.5.3`, fallback `192.168.122.1`.
- Ping internet 2/2, DNS repositori Alpine berhasil via Prab, `apk update` berhasil.
- `/root/install-molly-dynamic.sh` memasang `nginx php84 php84-fpm` (Nginx 1.28.3-r7, PHP 8.4.21-r0); `apk info -e` mengonfirmasi ketiganya.
- `/root/create-molly-pages.sh` membuat `/var/www/molly/index.php` dan `/var/www/molly/profil.php`, masing-masing seperti Oblada dengan judul `Beranda Core` / `Profil Core` dan `htmlspecialchars(gethostname(), ENT_QUOTES, 'UTF-8')`. Keduanya lolos `php84 -l`.
- PHP-FPM pool mendengarkan `127.0.0.1:9000`; `php-fpm84 -t` berhasil. `/root/configure-molly-nginx.sh` membuat `/etc/nginx/http.d/molly.conf` sesuai konfigurasi Oblada di atas, dengan `server_name molly.k17.com core.k17.com` dan `root /var/www/molly`; `nginx -t` berhasil. Daemon dimulai `php-fpm84 -D` dan `nginx`.
- Dari Alpha: `getent ahostsv4 molly.k17.com` menjawab `10.72.5.7`; HTTP pada `/` dan `/profil` masing-masing 200 dan menampilkan beranda/profil dengan `Dilayani oleh: molly`.

**Bukti akhir nomor 10:** ambil `10-core-php-rewrite-hostname.png` dari terminal Alpha yang memperlihatkan dua hostname (`oblada.k17.com` dan `molly.k17.com`) beserta HTTP 200 untuk beranda dan `/profil` serta identitas node. Ini menunjukkan tiap backend berfungsi langsung; pembagian trafik oleh Abbey akan diuji terpisah pada nomor 11.

## Catatan keberlanjutan

Skrip tersimpan di `/root` masing-masing node, tetapi start daemon setelah restart node **belum diuji**. Nomor 20 perlu memasang autostart dan uji ulang. Screenshot nomor 10 diterima dan diperiksa: `assets/10-core-php-rewrite-hostname.png`, berisi kedua IP, HTTP 200 untuk `/` dan `/profil`, serta identitas oblada dan molly.
