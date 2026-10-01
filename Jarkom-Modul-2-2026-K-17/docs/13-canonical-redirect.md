# Nomor 13 — Redirect nama kanonik gerbang K-17

## Ketentuan

| Gerbang | Sumber | Tujuan | Kode |
| --- | --- | --- | --- |
| Penny `10.72.4.2` | IP dan `penny.k17.com` | `www.k17.com` | 301 permanen |
| Abbey `10.72.3.2` | IP dan `abbey.k17.com` | `static.k17.com` | 302 sementara |

Nama kanonik `www.k17.com` dan `static.k17.com` diverifikasi dari Alpha masing-masing menuju IP gerbang yang benar dan memberi HTTP 200 sebelum perubahan.

## Penny (Apache)

Vhost utama `/etc/apache2/sites-available/penny-proxy.conf` dan skrip `/root/configure-penny-proxy.sh` diubah dari `ServerName penny.k17.com` menjadi `ServerName www.k17.com`; alias `www` yang lama dihapus. Proxy vault serta Basic Auth `/admin` tetap berada di vhost utama.

Skrip baru `/root/configure-penny-redirect.sh` membuat vhost `/etc/apache2/sites-available/001-penny-redirect.conf`:

```apache
<VirtualHost *:80>
    ServerName penny.k17.com
    Redirect permanent / http://www.k17.com/
</VirtualHost>
```

Situs `000-default` dinonaktifkan, situs `001-penny-redirect` diaktifkan. `apache2ctl configtest` `Syntax OK`; `apache2ctl -S` membuktikan `penny.k17.com` sebagai vhost default dan `www.k17.com` sebagai vhost layanan. Apache di-reload dengan `apache2ctl -k graceful`.

**Hasil Alpha:** `http://penny.k17.com/admin/` memberi `301 Location: http://www.k17.com/admin/`; `http://10.72.4.2/arsip/` memberi `301 Location: http://www.k17.com/arsip/`. Pada `www.k17.com/admin/` tanpa login, Basic Auth tetap memberi `401` dan header `WWW-Authenticate`. Empat akses `www.k17.com/` setelah perubahan menjawab Obladi, Desmond, Obladi, Desmond. Setelah nomor ini, uji login nomor 12 memakai alamat kanonik `www.k17.com/admin/`.

## Abbey (Nginx)

`/etc/nginx/http.d/abbey-proxy.conf` dan `/root/configure-abbey-proxy.sh` diubah agar vhost layanan memakai `server_name static.k17.com;`. Konfigurasi bawaan disalin ke `/root/abbey-default.before-redirect.conf`. Skrip `/root/configure-abbey-redirect.sh` membuat `/etc/nginx/http.d/default.conf`:

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name abbey.k17.com;
    return 302 http://static.k17.com$request_uri;
}
```

`nginx -t` berhasil dan `nginx -s reload` dilakukan. `$request_uri` mempertahankan path dan query.

**Hasil Alpha:** `http://abbey.k17.com/profil?uji=1` memberi `302 Location: http://static.k17.com/profil?uji=1`; `http://10.72.3.2/profil` memberi `302 Location: http://static.k17.com/profil`. URL kanonik `static.k17.com/profil` memberi HTTP 200 dan halaman profil. Empat akses ulang melalui `static.k17.com/profil` menampilkan Oblada tiga kali dan Molly sekali; kedua backend terjangkau melalui nama kanonik. Pembagian tepat 50:50 tidak dijanjikan dari sampel kecil.

## Bukti laporan

Screenshot `assets/13-canonical-redirect.png` diterima dan diperiksa: terminal Alpha menunjukkan dua pengalihan Penny dengan 301 dan `Location: http://www.k17.com/arsip/`, serta dua pengalihan Abbey dengan 302 dan `Location: http://static.k17.com/profil`. Konfigurasi setelah restart node belum diuji; nomor 20 memeriksa autostart.
