# Nomor 14 — IP pengunjung asli pada access log backend

## Ketentuan

Access log setiap server web vault (Obladi, Desmond) dan core (Oblada, Molly) harus mencatat IP asli pengunjung yang diteruskan gerbang Penny atau Abbey. Sebelum perubahan, backend menerima `X-Real-IP: 10.72.1.2` dari Alpha, tetapi alamat koneksi yang dicatat adalah IP proxy (`10.72.4.2` atau `10.72.3.2`).

## Obladi (Apache) — berhasil

Skrip `/root/configure-obladi-realip.sh` mengaktifkan `remoteip` dan memperbarui konfigurasi aktif `/etc/apache2/sites-available/obladi.conf` beserta skrip rekonstruksinya `/root/configure-obladi-web.sh`:

```apache
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 10.72.4.2
CustomLog /var/log/apache2/obladi-proxy.log "host=%{Host}i client=%a proxy=%{c}a status=%>s"
```

`RemoteIPInternalProxy` digunakan karena alamat pengunjung `10.72.1.2` termasuk IP privat; hanya IP Penny `10.72.4.2` yang dipercaya untuk mengirim header. `%a` menjadi IP client yang diproses modul, sedangkan `%{c}a` mempertahankan IP koneksi proxy. Apache `configtest` `Syntax OK`, lalu graceful reload. Enam akses Alpha ke `www.k17.com/` tersebar antara Desmond dan Obladi; tiga baris baru di log Obladi menunjukkan `host=www.k17.com client=10.72.1.2 proxy=10.72.4.2 status=200`. Baris lama berformat `real=... peer=...` tetap ada sebagai sejarah log. Ada baris lama `real=127.0.0.1` dari uji lokal Penny; ini bukan bukti trafik Alpha.

## Desmond (Apache) — berhasil

Skrip `/root/configure-desmond-realip.sh` mengaktifkan `remoteip` dan memperbarui `/etc/apache2/sites-available/desmond.conf` serta skrip `/root/configure-desmond-web.sh` dengan `RemoteIPHeader X-Real-IP`, `RemoteIPInternalProxy 10.72.4.2`, dan `CustomLog` berformat `host`, `client=%a`, `proxy=%{c}a`, `status`. Saat diperiksa ditemukan dua `CustomLog` identik pada kedua file; salinan kedua dihapus, sehingga masing-masing tinggal satu. `apache2ctl configtest` `Syntax OK`, graceful reload berhasil.

Enam permintaan Alpha ke `www.k17.com/` mencapai Desmond dan Obladi bergantian. Baris baru Desmond mencatat `host=www.k17.com client=10.72.1.2 proxy=10.72.4.2 status=200` tiga kali. Baris lama `real=... peer=...` tetap ada sebagai sejarah. Kedua backend vault sekarang terbukti memenuhi syarat.

## Oblada dan Molly (Nginx) — berhasil

Kedua container Alpine sudah memiliki `http_realip_module`. Sebelum perubahan, log khusus mereka menunjukkan `real=10.72.1.2 peer=10.72.3.2`: IP asli hanya terbaca sebagai header, sedangkan alamat koneksi Nginx masih Abbey.

Skrip `/root/configure-oblada-realip.sh` dan `/root/configure-molly-realip.sh` memperbarui vhost aktif `/etc/nginx/http.d/{oblada,molly}.conf` serta skrip pembuatnya `/root/configure-{oblada,molly}-nginx.sh`:

```nginx
log_format proxyproof "host=$host client=$remote_addr proxy=$realip_remote_addr status=$status";
server {
    set_real_ip_from 10.72.3.2;
    real_ip_header X-Real-IP;
    access_log /var/log/nginx/NAMA_NODE-proxy.log proxyproof;
    # aturan root, rewrite /profil, dan PHP-FPM yang telah ada tetap berlaku
}
```

`set_real_ip_from` hanya mempercayai Abbey. Nginx `nginx -t` berhasil lalu reload pada masing-masing node. Enam akses Alpha ke `static.k17.com/profil` pada tiap uji dibagikan ke Oblada dan Molly. Log baru Oblada maupun Molly masing-masing berisi `host=static.k17.com client=10.72.1.2 proxy=10.72.3.2 status=200` (tiga baris per uji). Kedua backend core memenuhi syarat. Baris lama `real=... peer=...` tetap ada dalam file log.

## Bukti akhir

Dua screenshot diterima dan diperiksa: `assets/14-vault-real-ip.png` menampilkan baris `client=10.72.1.2 proxy=10.72.4.2` pada Obladi dan Desmond; `assets/14-core-real-ip.png` menampilkan baris `client=10.72.1.2 proxy=10.72.3.2` pada Oblada dan Molly. Bukti akses Alpha yang menghasilkan baris tersebut ada di keluaran terminal yang sudah diperiksa. Setelah restart node, uji pemulihan layanan ulang pada nomor 20.
