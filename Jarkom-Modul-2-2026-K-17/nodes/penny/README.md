# Skrip asli Penny

Sumber: keluaran `cat /root/*.sh` yang dikirim Piramid pada 1 Oktober 2026. Delapan berkas disalin sesuai isi yang diterima; pemeriksaan `sh -n` hanya memeriksa sintaks shell, bukan keberhasilan layanan setelah restart.

| Berkas | Nomor / fungsi |
| --- | --- |
| setup-network.sh | 1–3: IP 10.72.4.2/24 dan gateway 10.72.4.1; DNS awal NAT |
| node-init.sh | Identitas, gateway, DNS internal; memerlukan IP eth0 sudah terpasang |
| install-penny-apache.sh | 11: pemasangan Apache |
| configure-penny-proxy.sh | 11, 12, 15: proxy Vault, admin lokal, pengecualian Eternal |
| configure-penny-redirect.sh | 13: redirect ke www.k17.com |
| install-penny-php.sh | 15: pemasangan PHP-FPM |
| create-penny-eternal.sh | 15: halaman PHP Eternal |
| configure-penny-eternal.sh | 15: penambahan aturan Eternal, kini sudah ada pada skrip proxy final |

## Langkah yang pernah dijalankan di luar skrip

Akun Basic Auth dibuat secara interaktif; password tidak disimpan dalam paket:

```sh
mkdir -p /etc/apache2/auth
htpasswd -cB /etc/apache2/auth/penny-users prabs
chown root:www-data /etc/apache2/auth/penny-users
chmod 640 /etc/apache2/auth/penny-users
```

Gunakan `-c` hanya saat membuat file baru karena opsi itu mengganti file akun yang sudah ada.

Pengaktifan integrasi PHP-FPM dilakukan manual dalam praktikum:

```sh
a2enmod proxy_fcgi setenvif
a2enconf php8.4-fpm
php-fpm8.4 -t
php-fpm8.4 -D
apache2ctl configtest
# Saat Apache sudah berjalan:
apache2ctl -k graceful
# Saat Apache belum berjalan, gunakan apache2ctl -k start.
```

Perintah start manual di atas tidak membuktikan autostart. Versi/binary PHP mengikuti node yang diuji (8.4). Ketersediaan CLI `php` perlu dicek jika melakukan instalasi baru; skrip pemasangan yang diterima hanya meminta `php-fpm`.

Urutan jaringan: `setup-network.sh` memasang IP/gateway dan DNS awal, kemudian `node-init.sh` mengganti DNS ke Prab/Tedd dan mengatur identitas. `node-init.sh` tidak mengatur IP dari nol dan tidak memulai Apache/PHP-FPM.

Skrip cadangan `configure-penny-proxy.before-admin.sh` tidak dimasukkan sebagai konfigurasi final. Bukti pengait startup (Docker startup command atau konfigurasi jaringan/init) dan hasil restart masih perlu dikumpulkan.
