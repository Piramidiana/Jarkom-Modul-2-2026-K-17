# Nomor 12 — Basic authentication `/admin` di Penny

## Tujuan

Jalur `http://penny.k17.com/admin` hanya dapat dibuka dengan akun yang ditetapkan dalam soal. Halaman ini berada **di Penny**; proxy umum tetap melayani halaman vault dari Obladi dan Desmond.

## Konfigurasi yang dijalankan

- Modul `auth_basic` dan `authn_file` aktif; utilitas `/usr/bin/htpasswd` tersedia.
- Pada Penny dibuat `/etc/apache2/auth/penny-users` untuk username `prabs` dengan `htpasswd -cB`. Password dimasukkan interaktif, **tidak dicatat di laporan atau skrip**. Berkas disetel pemilik `root:www-data` dan izin `640`; isinya hash, bukan teks password.
- Skrip konfigurasi Penny di `/root/configure-penny-proxy.sh` diperbarui. Salinan sebelumnya ada di `/root/configure-penny-proxy.before-admin.sh`.
- Halaman lokal Penny: `/var/www/penny/admin/index.html`, menampilkan `Ruang Admin Penny K-17`.
- Vhost `/etc/apache2/sites-available/penny-proxy.conf` mempertahankan dua backend nomor 11 dan menambahkan:

```apache
DocumentRoot /var/www/penny

# Letakkan sebelum ProxyPass "/" agar /admin tetap di Penny.
ProxyPass "/admin" "!"
ProxyPass "/" "balancer://vaultcluster/"
ProxyPassReverse "/" "balancer://vaultcluster/"

<LocationMatch "^/admin(?:/|$)">
    AuthType Basic
    AuthName "Ruang Admin Penny"
    AuthUserFile /etc/apache2/auth/penny-users
    Require valid-user
</LocationMatch>
```

`apache2ctl configtest` menghasilkan `Syntax OK` dan konfigurasi dimuat dengan `apache2ctl -k graceful`. `ProxyPass "/admin" "!"` mengecualikan admin dari proxy catch-all; `LocationMatch` menguji kredensial baik untuk `/admin` maupun `/admin/`.

## Bukti pengujian

- Di Penny: `/admin/` tanpa login menjawab HTTP 401 dan `WWW-Authenticate: Basic realm="Ruang Admin Penny"`. Halaman `/` tetap menampilkan `Repositori Statis Obladi`, sehingga proxy nomor 11 tetap bekerja.
- Dari Alpha melalui hostname: `/admin/` tanpa login HTTP 401; `curl -u prabs` meminta password secara interaktif dan menjawab HTTP 200 dengan `Ruang Admin Penny K-17`.
- Dari Alpha: path **`/admin`** tanpa garis miring akhir dan tanpa login juga HTTP 401 dengan header `WWW-Authenticate`.

Screenshot laporan diterima dan diperiksa: `assets/12-penny-basic-auth.png` menampilkan status 401 untuk `/admin/` tanpa login, status 200 serta isi halaman saat login interaktif, dan 401 untuk `/admin` tanpa slash. Password tidak tampak.

## Uji ulang

Hash akun dan halaman tersimpan pada Penny, tetapi proses Apache setelah restart node belum diuji. Autostart diverifikasi bersama pada nomor 20.
