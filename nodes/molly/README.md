# Skrip asli Molly — jaringan, nomor 10 dan 14

Enam skrip disalin dari keluaran console Molly pada 1 Oktober 2026. `setup-network.sh` memasang `10.72.5.7/24` dengan gateway `10.72.5.1`; `node-init.sh` memasang identitas, DNS internal, dan route setelah IP ada. `install-molly-dynamic.sh` memasang Nginx, PHP 8.4, dan PHP-FPM. `create-molly-pages.sh` menulis halaman PHP beranda dan profil. `configure-molly-nginx.sh` menyiapkan rewrite `/profil`, upstream PHP-FPM `127.0.0.1:9000`, dan log client/proxy. `configure-molly-realip.sh` hanya mempercayai Abbey `10.72.3.2` untuk `X-Real-IP`.

Skrip tidak memuat instruksi menjalankan daemon setelah restart; perlu pengait startup dan hasil uji nomor 20. Pemeriksaan `sh -n` hanya memeriksa sintaks skrip.
