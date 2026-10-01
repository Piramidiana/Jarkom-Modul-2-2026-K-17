# Skrip asli Obladi — jaringan, nomor 9, dan nomor 14

Lima berkas disalin dari console Obladi pada 1 Oktober 2026. `setup-network.sh` memasang IP `10.72.5.4/24` dan gateway `10.72.5.1`. `node-init.sh` mengatur nama dan resolver setelah IP ada. `install-obladi-apache.sh` memasang Apache. `configure-obladi-web.sh` menulis halaman serta virtual host final dengan arsip, alias, dan log. `configure-obladi-realip.sh` mengaktifkan modul remoteip dan menyesuaikan log pada vhost serta skrip pembuatnya.

`RemoteIPInternalProxy 10.72.4.2` hanya mempercayai Penny sebagai proxy. Berkas `penny-users` berada di Penny, bukan Obladi. Skrip tidak memuat perintah memulai Apache saat container restart; catat startup GNS3 atau daemon terpisah serta uji setelah restart pada nomor 20.
