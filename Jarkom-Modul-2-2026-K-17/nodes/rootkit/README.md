# Skrip Rootkit, nomor 1–3 dan pemulihan

Lima skrip di folder ini disalin dari isi `/root/*.sh` yang dikirim Piramid pada 1 Oktober 2026. `sh -n` memeriksa sintaks shell; keberhasilan startup sesudah restart belum dibuktikan oleh pemeriksaan itu.

| Skrip | Isi dan keadaan |
| --- | --- |
| `setup-rootkit-network.sh` | IP antarmuka dan default route; WAN di skrip masih `192.168.122.10/24`, sedangkan WAN terakhir yang teramati `192.168.122.237/24`. Periksa sumber DHCP/otomasi sebelum menjalankan ulang. |
| `setup-rootkit-nat.sh` | Forwarding dan MASQUERADE dari `10.72.0.0/16` melalui eth0; ada pemeriksaan agar rule NAT tidak diduplikasi. Pernah diuji. |
| `nat.sh` | Fungsi NAT sejenis skrip sebelumnya, dengan `echo` ke sysctl. Hanya perlu satu skrip NAT dalam jalur startup. |
| `nat-setup.sh` | Versi lain menambah rule NAT tanpa pemeriksaan dan rule FORWARD. Jangan jalankan berulang secara sembarang karena rule bisa bertambah; FORWARD sebelumnya berpolicy ACCEPT. |
| `rootkit-hostname.sh` | Nama host dan entri `/etc/hosts` untuk Rootkit. |

Daftar isi ini merekam **berkas nyata**, bukan rekomendasi mengeksekusinya bersamaan. Periksa rule `iptables -t nat -S POSTROUTING` dan `iptables -S FORWARD` serta konfigurasi startup Docker yang sebenarnya. Jangan mengunci WAN pada `.10` jika GNS3 NAT memberi alamat yang berubah.
