# Ekspor proyek GNS3

[`K-17-MODUL-2.gns3project`](K-17-MODUL-2.gns3project) adalah ekspor GNS3 yang diberikan kelompok pada 1 Oktober 2026. Pemeriksaan arsip: 268 entri terbaca, CRC seluruh entri benar, topologi berisi 22 node (14 Docker, 7 switch, 1 NAT) serta 21 link. Docker menggunakan image `ardhptr21/alpinet:latest` dan `ardhptr21/debinet:latest` yang perlu tersedia ketika mengimpor proyek.

Arsip berisi berkas proyek dan sebagian direktori node seperti `/root` serta `/etc/network`. Arsip **tidak berisi** file konfigurasi aktif dari `/etc/bind`, `/etc/apache2`, dan `/etc/nginx`; skrip di `../nodes/` membantu merekonstruksi bagian tersebut. Jangan mengklaim uji impor dan pemulihan layanan sudah berhasil sebelum diuji pada GNS3. Cek serial DNS aktual dan kebutuhan autostart sebelum demo.
