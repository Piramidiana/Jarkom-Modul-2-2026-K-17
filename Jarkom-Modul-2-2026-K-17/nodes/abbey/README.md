# Skrip asli Abbey — nomor 1–3, 11, 13, 15

Enam berkas disalin dari keluaran terminal Abbey tanggal 1 Oktober 2026. `configure-abbey-proxy.before-orion.sh` hanya cadangan tahap lama dan tidak dimasukkan sebagai konfigurasi akhir.

`setup-network.sh` memasang IP `10.72.3.2/24` dan gateway `10.72.3.1` sebelum `node-init.sh` mengatur DNS dan identitas. `install-abbey-nginx.sh` memasang Nginx. `create-abbey-orion.sh` menulis halaman lokal dan contoh PHP yang ditolak; `configure-abbey-proxy.sh` membuat upstream dua node Core dan aturan `/orion/`; `configure-abbey-redirect.sh` mengalihkan nama Abbey/IP ke `static.k17.com` dengan HTTP 302.

`nginx -t` ada dalam skrip konfigurasi, tetapi `nginx -s reload` dan start daemon sebelumnya dilakukan manual. Perlu pengait startup GNS3/Docker dan bukti uji setelah restart untuk nomor 20. Dilarang menganggap keberadaan berkas .sh sebagai bukti autostart.
