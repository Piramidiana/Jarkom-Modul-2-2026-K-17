# Kelengkapan pengumpulan K-17

## Sudah tersedia pada paket

- [x] README dan ringkasan laporan sesuai domain aktif k17.com.
- [x] Tabel IP dan dokumentasi web nomor 9–15.
- [x] Sembilan screenshot web nomor 9–15.
- [x] Lima skrip asli Rootkit dari `/root`, termasuk beberapa versi NAT; kondisi WAN di skrip lama perlu dicocokkan dengan kondisi akhir.
- [x] Delapan skrip Penny dari `/root` yang dikirim Piramid; sintaks shell diperiksa dengan `sh -n`.
- [x] Enam skrip aktif Abbey dari `/root`, termasuk proxy, redirect, dan Orion; sintaks shell diperiksa.
- [x] Lima skrip asli Obladi dari `/root`, termasuk web arsip dan pengolahan IP asli; sintaks shell diperiksa.
- [x] Lima skrip asli Desmond dari `/root`, termasuk web arsip dan pengolahan IP asli; sintaks shell diperiksa.
- [x] Tujuh skrip asli Oblada dari `/root`, termasuk dua alternatif konfigurasi jaringan, PHP, Nginx, dan IP asli; sintaks shell diperiksa.
- [x] Enam skrip asli Molly dari `/root`, termasuk web PHP, Nginx, dan log IP asli; sintaks shell diperiksa.
- [x] Ketujuh belas skrip Prab (`dns-vars.sh`, `dns-prab.sh`, tahap 1–5 termasuk 4b/4c, simulasi 18, serta tujuh skrip pendukung) diterima; zona final masih menunggu.

## Perlu diambil dari proyek / Jude

- [x] Ekspor `.gns3project` diterima dan 268 entri terverifikasi; konfigurasi aktif layanan di luar `/root`/`/etc/network` tidak terbawa, sehingga pemulihan dari skrip dan uji impor tetap diperlukan.
- [ ] Skrip `.sh` asli terbaru pada node klien serta Prab/Tedd, disusun per nomor dan node; periksa juga pengait autostart setiap node.
- [ ] Konfigurasi DNS master/slave, forward dan reverse zone final, serta serialnya.
- [x] Tujuh skrip Tedd dari console diterima; zona aktif Prab dan serial SOA aktual masih perlu dicek.
- [ ] Lengkapi zona aktif Prab; bandingkan serial `dns-vars.sh` 2026100103 dengan serial SOA aktual, serta verifikasi keluaran `dig` nyata pada uji cache.
- [ ] Screenshot topologi dan bukti jaringan nomor 1–3.
- [ ] Bukti DNS nomor 4–8.
- [ ] Hasil benchmark nomor 16 (output lengkap ab dan bukti kedua backend).
- [ ] TXT record nomor 17 dan hasil query yang sesuai tuntutan modul.
- [ ] Bukti TTL/caching nomor 18, serta pemulihan Abbey ke 10.72.3.2.
- [ ] Bukti CNAME dan HTTP nomor 19.
- [ ] Bukti nomor 20 setelah restart: jaringan, NAT, DNS, Apache, Nginx, PHP-FPM dan seluruh jalur web.

Laporan Jude yang dikirim memuat ketidaksesuaian nomor 7–8 (proxy, padahal pembagian sebelumnya DNS) dan contoh Penny memakai Nginx (proyek teruji memakai Apache). Gunakan konfigurasi aktual dan nomor dari modul sebelum menggabungkan laporan akhir. Klaim length errors sebagai bukti pembagian adil dan klaim rc.local sebagai jaminan reboot perlu diperbaiki berdasarkan hasil uji.
