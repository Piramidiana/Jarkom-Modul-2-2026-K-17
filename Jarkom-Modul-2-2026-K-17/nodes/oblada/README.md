# Skrip asli Oblada — jaringan, nomor 10 dan 14

Tujuh berkas disalin dari keluaran console Oblada pada 1 Oktober 2026. Dua skrip `setup-network.sh` dan `setup-oblada-network.sh` keduanya menyiapkan IP `10.72.5.6/24`, gateway `10.72.5.1` dan DNS awal; cukup pilih satu ketika memulihkan jaringan. `node-init.sh` mengatur nama dan DNS internal setelah IP terpasang. Versi di Oblada tidak menghapus baris `127.0.1.1` di `/etc/hosts`, berbeda dari skrip umum Penny.

`install-oblada-dynamic.sh` memasang Nginx dan PHP-FPM. `create-oblada-pages.sh` menulis halaman `/` dan `/profil`; `configure-oblada-nginx.sh` menulis vhost final dengan PHP-FPM di 127.0.0.1:9000 dan log IP asli yang hanya mempercayai Abbey `10.72.3.2`. `configure-oblada-realip.sh` mempertahankan konfigurasi log tersebut.

Skrip tidak secara eksplisit memulai Nginx/PHP-FPM setelah node restart; nomor 20 harus menyertakan pengait startup dan hasil uji.
