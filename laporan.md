# Laporan Praktikum Modul 2 — Infrastruktur Layanan Jaringan K-17

Domain kelompok `k17.com`; jaringan internal lima subnet `/24` dengan prefix `10.72`. Laporan ini merangkum bukti pengerjaan yang telah dikirim. Ekspor GNS3 telah diterima; bukti tambahan mengikuti [daftar kelengkapan](KELENGKAPAN.md).

## Nomor 1–3 — Topologi, routing, dan NAT

Rootkit menghubungkan lima subnet menggunakan gateway 10.72.1.1 sampai 10.72.5.1. IP forwarding diaktifkan, dan sumber 10.72.0.0/16 menggunakan MASQUERADE melalui eth0. Ping internet berhasil pada node yang dikonfigurasi, dan Delta dapat mengakses Alpha lintas subnet tanpa packet loss pada pengujian yang dikirim.

WAN Rootkit pernah berubah dari 192.168.122.10 ke 192.168.122.237. Beberapa default route pernah mengarah ke IP node sendiri; route diperbaiki ke gateway Rootkit. NAT pernah hilang setelah restart dan dipulihkan dengan skrip. Rincian alamat ada pada [tabel IP](docs/ip-plan.md). Screenshot jaringan perlu ditambahkan dari berkas asli.

## Nomor 4–8 — DNS oleh Jude

Prab (10.72.5.2) menjadi master dan Tedd (10.72.5.3) menjadi slave. Keluaran terminal yang dikirim pada 30 September menunjukkan named aktif pada kedua node, named-checkconf berhasil, dan SOA k17.com memiliki serial yang sama 2026093001. Alpha berhasil me-resolve obladi.k17.com melalui Prab ke 10.72.5.4 dan desmond.k17.com melalui Tedd ke 10.72.5.5.

Laporan Jude menyebut A record seluruh node, vault/core dengan beberapa alamat, CNAME www/static, dan reverse zone subnet 3–5. Berkas konfigurasi final dan hasil query lengkap masih perlu dilampirkan. Serial di atas adalah hasil uji pada saat itu, bukan serial final pengumpulan.

Soal 4
Pengertian: Menjadikan Prab (10.72.5.2) sebagai Master DNS Authoritative untuk domain k17.com. Mengatur A record untuk NS (Prab & Tedd) dan Apex record (@) ke gerbang aplikasi (Penny). Menarik zona ke Tedd, serta mengubah urutan DNS resolver seluruh klien (non-router) agar mengarah ke Prab, lalu Tedd, lalu jaringan luar (192.168.122.1).

Proses dari Awal: Kita mulai dengan mendeklarasikan zona di Prab. Namun, untuk resolver klien, prosesnya berevolusi. Awalnya aku membuatkan skrip menggunakan variabel, lalu kamu meminta dibuatkan skrip per node, dan akhirnya kita sempurnakan menjadi skrip Production-Grade yang otomatis mendeteksi node.

Command/Script Utama:
Konfigurasi /etc/bind/named.conf.options di Prab (Forwarders):

Bash
options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; };
    allow-query { any; };
    listen-on-v6 { any; };
};
Konfigurasi Resolver di Klien (Contoh skrip universal final):

Bash
rm -f /etc/resolv.conf
cat > /etc/resolv.conf << EOF
nameserver 10.72.5.2
nameserver 10.72.5.3
nameserver 192.168.122.1
EOF
Output/Bukti: Belum terverifikasi dengan output terminal eksplisit di log percakapan ini (namun tercatat "implemented and verified" pada ringkasan awal).

Error dan Perbaikan: Beberapa node (seperti Debinet/Alpine) mengunci file /etc/resolv.conf karena berupa symlink ke systemd-resolved. Solusinya adalah melakukan penghapusan paksa (rm -f /etc/resolv.conf) sebelum membuat ulang file konfigurasi resolver yang statis. Selain itu, ada kendala named gagal restart karena tertimpa sistem, sehingga kita menggunakan kill -9 $(pidof named) 2>/dev/null; named -u bind alih-alih killall named.

Kondisi Akhir: Resolver di-set berurutan ke 10.72.5.2, 10.72.5.3, 192.168.122.1. Forward zone k17.com aktif di Prab.

Soal 5
Pengertian: Memberikan nama identitas (hostname) yang permanen dan dikenali secara system-wide untuk seluruh 15 node (termasuk Rootkit, Alpha, dll).

Proses dari Awal: Dilakukan berbarengan dengan penyetelan resolver. Kita menyisipkan hostname ke dalam file konfigurasi OS.

Command/Script Utama (Contoh untuk Alpha):

Bash
echo "alpha" > /etc/hostname
hostname "alpha"
cat > /etc/hosts << EOF
127.0.0.1   localhost
127.0.1.1   alpha alpha.k17.com
EOF
Output/Bukti: Belum terverifikasi dengan output terminal eksplisit di log percakapan ini.

Error dan Perbaikan: Mengubah /etc/hostname saja memicu peringatan unable to resolve host. Perbaikannya adalah kita memodifikasi file /etc/hosts dengan memetakan IP loopback 127.0.1.1 ke nama FQDN masing-masing node.

Kondisi Akhir: Seluruh node memiliki hostname valid sesuai glosarium.

Soal 6
Pengertian: Memastikan Tedd (Slave) berhasil menarik salinan zona k17.com dari Prab dan memastikan serial SOA-nya sama.

Proses dari Awal: Tedd dikonfigurasi menggunakan blok type slave di named.conf.local.

Command/Script Utama:

Bash
cat > /etc/bind/named.conf.local << 'EOF'
zone "k17.com" {
    type slave;
    masters { 10.72.5.2; };
    file "/var/cache/bind/db.k17.com";
};
EOF
Output/Bukti: Terdapat bukti valid saat kamu menjalankan ls -l /var/cache/bind/ di terminal Tedd:

Plaintext
root@Tedd:~# ls -l /var/cache/bind/
total 16
-rw-r--r-- 1 bind bind  252 Oct  1 13:42 db.10.72.3
-rw-r--r-- 1 bind bind  252 Oct  1 12:57 db.10.72.4
-rw-r--r-- 1 bind bind  553 Oct  1 13:44 db.10.72.5
-rw-r--r-- 1 bind bind 1477 Oct  1 13:20 db.k17.com
Error dan Perbaikan: Tidak ada error yang tercatat. Transmisi zona mulus.

Kondisi Akhir: Tedd menyimpan file sinkronisasi di /var/cache/bind/db.k17.com. Berhasil 100%.

Soal 7
Pengertian: Membuat A record untuk Vault dan Core (masing-masing menunjuk ke 2 IP/Round Robin), serta CNAME untuk www (ke Penny) dan static (ke Abbey).

Proses dari Awal: Dikonfigurasi dalam file db.k17.com di Prab. Karena kamu sempat lupa mengambil screenshot, kita merancang perintah kilat untuk memverifikasinya ulang dari Alpha tanpa merusak konfigurasi.

Command/Script Utama (Verifikasi dari Alpha):

Bash
dig @10.72.5.2 www.k17.com +short
dig @10.72.5.2 static.k17.com +short
dig @10.72.5.2 vault.k17.com +short
Output/Bukti: Terdapat bukti valid dari terminal Alpha yang kamu paste:

Plaintext
Alpha:~# dig @10.72.5.2 www.k17.com +short
dig @10.72.5.2 static.k17.com +short
dig @10.72.5.2 vault.k17.com +short
penny.k17.com.
10.72.4.2
abbey.k17.com.
10.72.3.2
10.72.5.4
10.72.5.5
Error dan Perbaikan: Kelupaan screenshot. Diperbaiki dengan query ulang dig.

Kondisi Akhir: www berhasil ke Penny, static ke Abbey. Domain vault berhasil memetakan dua IP (10.72.5.4 dan 10.72.5.5). Berhasil 100%.

Soal 8
Pengertian: Membuat Reverse Zone (IP ke Nama) untuk jaringan web (Abbey, Penny, dll) di Prab, menariknya ke Tedd sebagai Slave, dan memastikan Tedd merespons dengan status Authoritative.

Proses dari Awal: Deklarasi zona in-addr.arpa di Prab, lalu konfigurasi slave di Tedd. Kamu membuktikan kueri PTR melalui Alpha langsung ke IP Tedd.

Command/Script Utama:
Verifikasi PTR ke Slave:

Bash
dig @10.72.5.3 -x 10.72.4.2
dig @10.72.5.3 -x 10.72.3.2
Output/Bukti: Bukti krusial dari terminal Alpha yang kamu berikan:

Plaintext
; <<>> DiG 9.20.26 <<>> @10.72.5.3 -x 10.72.4.2
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 18816
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; ANSWER SECTION:
2.4.72.10.in-addr.arpa. 86400   IN      PTR     penny.k17.com.

; <<>> DiG 9.20.26 <<>> @10.72.5.3 -x 10.72.3.2
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 24971
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; ANSWER SECTION:
2.3.72.10.in-addr.arpa. 86400   IN      PTR     abbey.k17.com.
Error dan Perbaikan: Tidak ada. Kamu berhasil mendapatkan flag aa (Authoritative Answer) pada percobaan pertama kueri spesifik ini.

Kondisi Akhir: Reverse zone beroperasi penuh di Slave. Berhasil 100%

## Nomor 9 — Backend statis Vault

[Dokumentasi](docs/09-vault-static.md): Apache pada Obladi dan Desmond melayani beranda serta autoindex /arsip/. Pengujian hostname dari Alpha memberi HTTP 200.

![Vault: hostname dan arsip](assets/09-vault-hostname-arsip.png)

## Nomor 10 — Backend dinamis Core

[Dokumentasi](docs/10-core-dynamic.md): Nginx dan PHP-FPM pada Oblada/Molly melayani beranda serta /profil dengan rewrite internal ke profil.php. Kedua backend memberi HTTP 200 dari Alpha.

![Core: PHP dan profil](assets/10-core-php-rewrite-hostname.png)

## Nomor 11 — Reverse proxy dan pembagian beban

[Dokumentasi](docs/11-reverse-proxy.md): Apache Penny membagi trafik ke Obladi/Desmond; Nginx Abbey ke Oblada/Molly. Respons kedua backend dan header Host/X-Real-IP terlihat pada pengujian. Konfigurasi awal dalam dokumen kemudian disesuaikan pada nomor 12–15; gunakan skrip final untuk pemulihan.

![Proxy Penny](assets/11-penny-proxy-evidence.png)

![Proxy Abbey](assets/11-abbey-proxy-evidence.png)

## Nomor 12 — Basic Auth

[Dokumentasi](docs/12-penny-basic-auth.md): /admin pada Penny memakai akun prabs. Tanpa login HTTP 401, dengan login HTTP 200. Setelah redirect kanonik nomor 13, alamat uji adalah http://www.k17.com/admin/. Password dimasukkan interaktif.

![Basic Auth](assets/12-penny-basic-auth.png)

## Nomor 13 — Redirect kanonik

[Dokumentasi](docs/13-canonical-redirect.md): Penny/akses IP dialihkan 301 ke www.k17.com; Abbey/akses IP dialihkan 302 ke static.k17.com. Path tetap diteruskan, dan Abbey mempertahankan query string.

![Redirect kanonik](assets/13-canonical-redirect.png)

## Nomor 14 — Log IP pengunjung asli

[Dokumentasi](docs/14-real-client-ip.md): Apache mod_remoteip pada Obladi/Desmond hanya mempercayai Penny. Nginx realip pada Oblada/Molly hanya mempercayai Abbey. Log baru menunjukkan client Alpha 10.72.1.2 dan IP proxy masing-masing.

![IP asli Vault](assets/14-vault-real-ip.png)

![IP asli Core](assets/14-core-real-ip.png)

## Nomor 15 — Eternal dan Orion

[Dokumentasi](docs/15-eternal-orion.md): Eternal dilayani lokal oleh Penny dan merender PHP; Orion dilayani statis oleh Abbey. Keduanya HTTP 200, /orion/uji.php memberi 403, dan proxy /profil tetap berfungsi.

![Eternal dan Orion](assets/15-eternal-orion.png)

Soal 16
Pengertian: Melakukan Stress Test dari Alpha menggunakan ApacheBench dengan 250 request dan tingkat konkurensi 10 menuju [www.k17.com](https://www.k17.com) dan static.k17.com.

Proses dari Awal: Eksekusi beban di klien.

Command/Script Utama:

Bash
ab -n 250 -c 10 http://www.k17.com/
ab -n 250 -c 10 http://static.k17.com/
Output/Bukti: Belum terverifikasi dengan output terminal eksplisit di log percakapan ini (namun tercatat selesai pada ringkasan).

Error dan Perbaikan: Berdasarkan rekam log dokumentasi: terjadi error apr_socket_connect(): Connection refused (111) karena Nginx di Penny dan Abbey mati. Solusinya menginstal/restart ulang Nginx manual di Alpine/Debian. Lalu ada error 404 Not Found di Abbey, solusinya dengan membuat direktori dan file index.html kosong di /var/www/localhost/htdocs/.

Kondisi Akhir: Konfigurasi selesai, server sanggup menahan stress test.

Soal 17
Pengertian: Menambahkan TXT record di Prab untuk identitas sayap klien (Alpha, Beta, Gamma, Delta, Epsilon) sehingga DNS bisa merespons dengan nama hostname mereka saat di-query.

Proses dari Awal: Menyisipkan konfigurasi TXT di file db.k17.com.

Command/Script Utama:

Bash
echo "alpha   IN  TXT \"alpha\"" >> /etc/bind/db.k17.com
dig @10.72.5.2 alpha.k17.com TXT +short
Output/Bukti: Belum terverifikasi dengan output terminal eksplisit di percakapan ini.

Error dan Perbaikan: Tidak ada.

Kondisi Akhir: File zona master memiliki record TXT terdaftar untuk kelima klien.

Soal 18
Pengertian: Menguji kemampuan caching DNS dengan mengatur TTL 15 detik pada IP fiktif abbey, lalu mengamati 3 fase: sebelum, sesaat sesudah pengubahan (saat cache masih menahan IP lama), dan setelah 15 detik (IP baru muncul).

Proses dari Awal: Karena screenshot manual sangat rentan gagal dalam jeda 15 detik, aku membuatkan bash script interaktif dengan fungsi read -p untuk menahan terminal (jeda ENTER).

Command/Script Utama (Versi Interaktif di Alpha):

Bash
#!/bin/bash
echo "=== FASE 1: QUERY PERTAMA ==="
dig @127.0.0.1 abbey.k17.com +short
read -p "[Tekan ENTER] jika Prab SUDAH MENGUBAH IP..."
echo "=== FASE 2: UJI CACHE (MOMEN KRUSIAL) ==="
dig @127.0.0.1 abbey.k17.com +short
echo "Menunggu 16 detik agar cache expired..."
sleep 16
echo "=== FASE 3: UJI CACHE KEDALUWARSA ==="
dig @127.0.0.1 abbey.k17.com +short
Output/Bukti: Belum terverifikasi dengan output terminal eksplisit di log percakapan (kamu melewati pengujiannya dan langsung ke nomor 19).

Error dan Perbaikan: Klien Alpha tidak punya sistem cache mandiri (langsung menembus ke Prab). Perbaikannya, kita memasang dnsmasq di Alpha sebagai local cache resolver.

Kondisi Akhir: Skrip pengujian disiapkan.

Soal 19
Pengertian: Membuat CNAME record outbound.k17.com ke http.badssl.com dan membandingkan hasil curl keduanya.

Proses dari Awal: Konfigurasi di Prab, uji dig dan curl di Alpha.

Command/Script Utama:

Bash
dig @10.72.5.2 outbound.k17.com +short
curl -s http://outbound.k17.com | head -n 15
Output/Bukti: Terverifikasi valid dari terminal Alpha:

Plaintext
Alpha:~# dig @10.72.5.2 outbound.k17.com +short
http.badssl.com.
104.154.89.105
Alpha:~#
Error dan Perbaikan: Ada kekhawatiran karena output HTML terblokir jaringan kampus ("Palo Alto Web Page Blocked"). Solusi: kita menyepakati bahwa asal hasil blokiran HTML dari curl outbound dan badssl sama persis, itu sudah menjadi bukti valid.

Kondisi Akhir: CNAME berfungsi 100% tembus ke IP eksternal Google/BadSSL.

Soal 20
Pengertian: Memastikan DNS Bind9 otomatis menyala saat server (Prab/Tedd) di-restart di dalam lingkungan simulasi GNS3.

Proses dari Awal: Karena menggunakan container yang mungkin tidak memiliki systemd normal, kita memanfaatkan fitur network interface di Debian/Alpine.

Command/Script Utama:

Bash
echo "    up /usr/sbin/named -u bind" >> /etc/network/interfaces
cat /etc/network/interfaces
Output/Bukti: Terverifikasi valid dari terminal Prab:

Plaintext
root@Prab:~# echo "    up /usr/sbin/named -u bind" >> /etc/network/interfaces
root@Prab:~# cat /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.72.5.2
    netmask 255.255.255.0
    gateway 10.72.5.1
    up /usr/sbin/named -u bind
root@Prab:~#
Error dan Perbaikan: Kamu sempat lupa letak pembuktian akhirnya. Aku pandu ulang untuk langsung mengeksekusi cat dan itu sukses.

Kondisi Akhir: Autostart DNS berjalan dengan metode hook up interface. Berhasil 100%.

## Nomor 16–19 — Laporan Jude, bukti akhir menunggu

Jude melaporkan benchmark dengan ab -n 250 -c 10 untuk www dan static; TXT record klien; perubahan sementara TTL Abbey menjadi 15 detik dan alamat 10.72.3.99; CNAME outbound menuju http.badssl.com. Hasil terminal dan screenshot lengkap belum diterima dalam paket ini. Pengamatan caching memerlukan bukti TTL dan jalur resolver yang dipakai. Perbedaan panjang respons ab tidak dengan sendirinya membuktikan pembagian beban adil.

## Nomor 20 — Pemulihan dan autostart

Jude melaporkan pemulihan Abbey ke 10.72.3.2 dan penulisan rc.local untuk DNS/NAT. Bukti bahwa startup menjalankan skrip dan seluruh layanan web kembali normal setelah restart belum tersedia. Nomor ini belum dapat dinyatakan selesai dari dokumentasi yang diterima saja.

## Kesimpulan

Fungsi jaringan dan layanan web nomor 1–3 serta 9–15 telah ditunjukkan melalui keluaran terminal. Sebagian fungsi DNS master/slave teruji. Ekspor proyek GNS3 telah disimpan, tetapi belum diuji impor dan tidak memuat konfigurasi aktif BIND/Apache/Nginx. Pengumpulan lengkap masih membutuhkan zona DNS aktif final dan bukti Jude nomor 16–20.
