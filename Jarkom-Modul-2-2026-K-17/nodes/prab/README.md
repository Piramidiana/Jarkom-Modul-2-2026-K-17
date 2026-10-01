# Skrip Prab yang sudah diterima (belum lengkap)

Ketujuh belas berkas ini disalin dari keluaran console Prab 1 Oktober 2026. Skrip utama `dns-prab.sh` memanggil tahap 1, 2, 3, 4, 4b, 4c, 5 secara berurutan. Seluruh skrip Prab yang dilaporkan sudah diterima, tetapi konfigurasi zona aktif final setelah uji nomor 18 belum diterima. Jangan jalankan ulang skrip utama sebelum memeriksa keadaan zona aktif.

`nat.sh` ditemukan di Prab, tetapi perintahnya memasang NAT pada `eth0`; fungsi ini milik router Rootkit. Simpan sebagai arsip asli dan **jangan jalankan di Prab**. `install-dns.sh` menyebut `bind9utils`, sedangkan skrip utama tahap 1 memasang `bind9-utils`; jangan menganggap kedua skrip instalasi ini sama-sama berhasil tanpa melihat keluaran `apt`.

Tahap 1 memasang paket BIND dan menulis opsi resolver/forwarder. Tahap 2 mendefinisikan zona forward dan reverse master. Tahap 3 menulis ulang `/etc/bind/db.k17.com` dari awal; perubahan record yang ditambah pada tahap berikutnya harus diperiksa sebelum mengulanginya.

Tahap 4 menambah A `vault`/`core`, CNAME `www`/`static`, dan membuat reverse zone 3–5. Tahap 4b menambah TXT untuk lima klien. Tahap 4c menambah CNAME `outbound`. Karena tahap 4b dan 4c menggunakan append (`>>`), menjalankannya terpisah berulang dapat menduplikasi record; tahap 3 justru menimpa seluruh file zona. Arsipkan zona aktif sebelum perubahan apa pun.

`dns-vars.sh` berisi SERIAL `2026100103`. Ini adalah isi berkas yang diterima, bukan kepastian nomor serial SOA final; periksa berkas zona di Prab dan slave sebelum menjalankan ulang. `dns-prab-5.sh` memeriksa zona, menghidupkan named, lalu menguji SOA lokal. Ia menghentikan named dan mengganti resolver jika dijalankan.

`simulasi-18.sh` mencetak harapan hasil TTL 1.1.1.1 ke 2.2.2.2 dan memanggil `dig @127.0.0.1`. Teks `echo` bukan bukti jawaban DNS; perlu hasil `dig` nyata pada resolver caching yang terpisah dan query otoritatif untuk membuktikan masa cache. Jangan jalankan dalam kondisi akhir bila zona nomor 18 sudah dinormalisasi.
