# Skrip asli Desmond — jaringan, nomor 9, dan nomor 14

Lima berkas disalin dari keluaran console Desmond pada 1 Oktober 2026. IP `10.72.5.5/24`, gateway `10.72.5.1`. `configure-desmond-web.sh` menulis halaman arsip dan vhost final. `configure-desmond-realip.sh` mengaktifkan `remoteip` yang hanya mempercayai Penny `10.72.4.2`, dengan format log IP client dan IP proxy.

`node-init.sh` mengatur nama host dan DNS setelah IP tersedia. Pemulihan otomatis Apache setelah restart dan persistensi data container harus dibuktikan pada nomor 20; `sh -n` hanya memeriksa sintaks skrip.
