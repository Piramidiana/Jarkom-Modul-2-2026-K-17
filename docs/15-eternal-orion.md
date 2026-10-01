# Nomor 15 — `/eternal` dan `/orion`

## Ketentuan dan keadaan

- Penny: path `/eternal` menyajikan direktori `/var/www/eternal` dan merender PHP. Penny juga tetap menjadi reverse proxy vault untuk path lain.
- Abbey: path `/orion` menyajikan direktori `/var/www/orion` sebagai berkas statis tanpa rendering PHP. Konfigurasi dan uji selesai.

## Penny `10.72.4.2` — selesai, diuji dari Alpha

Pada Debian 13 dipasang `php-fpm` (`php8.4-fpm` 8.4.26) melalui `/root/install-penny-php.sh`. Container tidak memulai service secara otomatis (`policy-rc.d denied execution of start`), maka PHP-FPM diperiksa dengan `php-fpm8.4 -t` dan dijalankan dengan `php-fpm8.4 -D`. Socket `/run/php/php8.4-fpm.sock` muncul dengan owner `www-data:www-data`. Apache mengaktifkan `proxy_fcgi`, `setenvif`, dan `php8.4-fpm` melalui `a2enmod`/`a2enconf`; `apache2ctl configtest` `Syntax OK`.

Skrip `/root/create-penny-eternal.sh` membuat `/var/www/eternal/index.php`. Halaman menampilkan `PHP_VERSION` melalui PHP dan menyebut peran Penny secara eksplisit karena hostname sistem di container ternyata `rootkit`. `php -l` tidak menemukan kesalahan sintaks.

Skrip `/root/configure-penny-eternal.sh` memperbarui `/etc/apache2/sites-available/penny-proxy.conf` **dan** `/root/configure-penny-proxy.sh` dengan pengecualian proxy sebelum aturan catch-all:

```apache
ProxyPass "/eternal" "!"
ProxyPass "/admin" "!"
ProxyPass "/" "balancer://vaultcluster/"
ProxyPassReverse "/" "balancer://vaultcluster/"

Alias "/eternal/" "/var/www/eternal/"
RedirectMatch 302 "^/eternal$" "/eternal/"
<Directory "/var/www/eternal">
    Options FollowSymLinks
    DirectoryIndex index.php
    Require all granted
</Directory>
```

`apache2ctl configtest` `Syntax OK`, lalu `apache2ctl -k graceful`. Dari Penny lewat localhost dan `Host: www.k17.com`, `/eternal/` menjawab HTTP 200 dengan `PHP aktif di Penny, versi 8.4.26`. Dari Alpha, `http://www.k17.com/eternal/` juga HTTP 200 dengan versi PHP yang sama; `/eternal` menjawab HTTP 302 dengan `Location: http://www.k17.com/eternal/`; root `www.k17.com/` masih mengembalikan halaman repositori Obladi. Ini membuktikan path khusus tidak mengganggu proxy vault.

## Abbey `10.72.3.2` — selesai, diuji dari Alpha

Skrip `/root/create-abbey-orion.sh` membuat `/var/www/orion/index.html` dan berkas uji `/var/www/orion/uji.php` yang berisi penanda `PHP_DIEKSEKUSI`. Skrip proxy lama dibackup sebagai `/root/configure-abbey-proxy.before-orion.sh`; `/root/configure-abbey-proxy.sh` kini menulis `/etc/nginx/http.d/abbey-proxy.conf` dengan aturan berikut di dalam vhost `static.k17.com`, sementara `location /` tetap meneruskan ke Oblada/Molly:

```nginx
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
```

`nginx -t` berhasil; `nginx -s reload` dilakukan. Uji lokal pertama segera sesudah reload menghasilkan 404 untuk `/orion/` dan `uji.php`, tetapi pemeriksaan berikutnya menunjukkan `/orion/index.html` HTTP 200, `uji.php` HTTP 403, dan pengulangan `/orion/` HTTP 200. Penyebab respons awal 404 belum dipastikan; uji ulang dari Alpha kini konsisten.

Dari Alpha, `http://www.k17.com/eternal/` HTTP 200 dengan PHP 8.4.26; `http://static.k17.com/orion/` HTTP 200 dengan halaman statis Abbey; `http://static.k17.com/orion/uji.php` HTTP 403; `http://static.k17.com/profil` masih dilayani Oblada. Ini membuktikan aturan lokal khusus tidak memutus proxy yang sudah ada.

## Bukti dan kelanjutan

Screenshot gabungan terminal Alpha `assets/15-eternal-orion.png` diterima dan diperiksa: HTTP 200 PHP Penny (versi 8.4.26), HTTP 200 halaman statis Orion Abbey, HTTP 403 untuk `uji.php`, dan profil tetap dilayani Oblada. Setelah restart, PHP-FPM dan Apache mungkin harus dinyalakan ulang; uji autostart di nomor 20.
