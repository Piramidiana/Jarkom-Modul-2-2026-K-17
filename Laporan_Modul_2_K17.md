# LAPORAN PRAKTIKUM MODUL 2

## Identitas Kelompok

| Keterangan | Isi |
| --- | --- |
| Kelompok | K-17 |
| Project GNS3 | K-17-MODUL-2 |
| Domain | `k17.com` |
| Anggota 1 | Dian Piramidiana Rachmatika — 5027251031 |
| Anggota 2 | Jude Athala Yazid Sari — 5027251098 |

File proyek terdapat di [01_Project_GNS3/K-17-MODUL-2.gns3project](01_Project_GNS3/K-17-MODUL-2.gns3project). Skrip disusun dalam [02_Scripts_Per_Soal](02_Scripts_Per_Soal/), dengan awalan nama node pada setiap skrip. Alamat lengkap ada pada [tabel IP](docs/ip-plan.md).

## 1. Topologi dan Alamat IP

Rootkit menghubungkan lima jaringan `10.72.1.0/24` hingga `10.72.5.0/24` melalui switch. `eth0` Rootkit terhubung ke NAT1. Prab dan Tedd berada di subnet 5; Penny di subnet 4; Abbey di subnet 3. Ekspor proyek memuat 22 node dan 21 link.

Skrip terkait: [Soal_01](02_Scripts_Per_Soal/Soal_01/). **Bukti yang perlu ditambahkan:** `04_Dokumentasi/assets/01-topologi.png`, tangkapan seluruh topologi dengan nama node dan link terlihat.

## 2. Koneksi Rootkit ke Internet

Rootkit menggunakan gateway NAT1 `192.168.122.1` pada `eth0`. Ping dari Rootkit ke `8.8.8.8` pernah berhasil (2/2 pada pemeriksaan yang dikirim). Alamat WAN berubah selama praktik, sehingga nilai `192.168.122.10` pada skrip awal tidak boleh dianggap IP final.

Skrip: [Soal_02](02_Scripts_Per_Soal/Soal_02/). **Bukti yang perlu ditambahkan:** `02-rootkit-internet.png`, berisi IP `eth0`, route, dan ping.

## 3. Routing, NAT, dan Resolver

Rootkit mengaktifkan `ip_forward=1` dan MASQUERADE untuk `10.72.0.0/16` yang keluar melalui `eth0`. Klien memakai gateway `.1` di subnet masing-masing. Delta berhasil ping ke Alpha lintas subnet 3/3; beberapa klien juga berhasil ping ke `8.8.8.8`. Setelah restart aturan NAT sempat hilang, lalu dipasang kembali lewat `setup-rootkit-nat.sh`.

Skrip: [Soal_03](02_Scripts_Per_Soal/Soal_03/). **Bukti yang perlu ditambahkan:** `03-routing-nat.png`, tampilkan `ip route`, `ip_forward`, aturan POSTROUTING, dan satu ping lintas subnet.

## 4. DNS Master dan Secondary

Prab (`10.72.5.2`) menjadi DNS utama dan Tedd (`10.72.5.3`) menyalin zona `k17.com`. Skrip asli Tedd menggunakan istilah BIND `type secondary; primaries { 10.72.5.2; };`. Pada pemeriksaan 30 September, kedua `named` aktif, `named-checkconf` berhasil, dan keduanya menjawab SOA serial `2026093001`. Itu hasil pada waktu pemeriksaan, bukan kepastian serial final.

Skrip: [Soal_04](02_Scripts_Per_Soal/Soal_04/). **Bukti yang perlu ditambahkan:** `04-dns-prab-tedd.png`, memuat hasil SOA dari kedua server.

## 5. Identitas Node (A Record)

Zona Prab memetakan `alpha` sampai `molly` ke alamat subnet masing-masing. Alpha pernah berhasil menanyakan `obladi.k17.com` ke Prab dan `desmond.k17.com` ke Tedd, masing-masing mendapat `10.72.5.4` dan `10.72.5.5`. File zona aktif final belum disalin dari Prab.

Skrip: [Soal_05](02_Scripts_Per_Soal/Soal_05/). **Bukti yang perlu ditambahkan:** `05-a-record.png`, hasil beberapa `dig @10.72.5.2` dan `dig @10.72.5.3`.

## 6. Sinkronisasi Zona

Tedd dikonfigurasi mengambil zona forward dan reverse dari Prab. Kedua server pernah menjawab SOA yang sama pada pemeriksaan awal. Serial terbaru serta hasil `rndc retransfer` perlu dicocokkan setelah perubahan nomor 17–20.

Skrip: [Soal_06](02_Scripts_Per_Soal/Soal_06/). **Bukti yang perlu ditambahkan:** `06-zone-transfer.png`, tampilkan SOA kedua server dan status transfer.

## 7. Record Vault, Core, dan Alias

Skrip Prab menambah dua A record pada `vault` (`10.72.5.4`, `10.72.5.5`) dan `core` (`10.72.5.6`, `10.72.5.7`), serta CNAME `www` ke Penny dan `static` ke Abbey. Saat diuji dari Alpha, `www.k17.com` menuju Penny dan `static.k17.com` menuju Abbey.

Skrip: [Soal_07](02_Scripts_Per_Soal/Soal_07/). **Bukti yang perlu ditambahkan:** `07-dns-layanan.png`, hasil `dig` dua alamat dan CNAME.

## 8. Reverse DNS

Skrip Prab membuat zona reverse subnet 3, 4, dan 5, termasuk PTR untuk Abbey, Penny, Prab, Tedd, Vault, dan Core. Bukti query PTR final belum diserahkan; tidak disimpulkan berhasil hanya dari isi skrip.

Skrip: [Soal_08](02_Scripts_Per_Soal/Soal_08/). **Bukti yang perlu ditambahkan:** `08-ptr.png`, hasil `dig -x` ke DNS Prab dan Tedd.

## 9. Web Statis Vault

Apache pada Obladi dan Desmond menyajikan halaman repositori dan daftar isi `/arsip/`. Alpha memperoleh HTTP 200 dari kedua hostname. [Skrip](02_Scripts_Per_Soal/Soal_09/) · [Penjelasan](docs/09-vault-static.md).

![Uji web Vault](04_Dokumentasi/assets/09-vault-hostname-arsip.png)

## 10. Web Dinamis Core

Nginx dan PHP-FPM pada Oblada/Molly menyajikan beranda dan `/profil`; respons memuat nama backend. Kedua node memberi HTTP 200 dari Alpha. [Skrip](02_Scripts_Per_Soal/Soal_10/) · [Penjelasan](docs/10-core-dynamic.md).

![Uji web Core](04_Dokumentasi/assets/10-core-php-rewrite-hostname.png)

## 11. Reverse Proxy

Apache Penny membagi permintaan ke Obladi/Desmond, sedangkan Nginx Abbey ke Oblada/Molly. Permintaan berulang dari Alpha menampilkan kedua backend. [Skrip](02_Scripts_Per_Soal/Soal_11/) · [Penjelasan](docs/11-reverse-proxy.md).

![Uji Penny](04_Dokumentasi/assets/11-penny-proxy-evidence.png)

![Uji Abbey](04_Dokumentasi/assets/11-abbey-proxy-evidence.png)

## 12. Basic Auth Penny

Halaman `/admin/` pada Penny memakai akun `prabs`. Tanpa login respons 401, dengan password yang dimasukkan secara interaktif respons 200. Password tidak dicantumkan dalam repositori. [Skrip](02_Scripts_Per_Soal/Soal_12/) · [Penjelasan](docs/12-penny-basic-auth.md).

![Uji Basic Auth](04_Dokumentasi/assets/12-penny-basic-auth.png)

## 13. Redirect Domain

Penny mengalihkan `penny.k17.com` dan akses IP ke `www.k17.com` dengan 301. Abbey mengalihkan `abbey.k17.com` dan akses IP ke `static.k17.com` dengan 302. Path dan query string diuji tetap terbawa. [Skrip](02_Scripts_Per_Soal/Soal_13/) · [Penjelasan](docs/13-canonical-redirect.md).

![Uji redirect](04_Dokumentasi/assets/13-canonical-redirect.png)

## 14. Alamat IP Klien di Backend

Backend Vault hanya mempercayai proxy Penny `10.72.4.2`; backend Core hanya mempercayai proxy Abbey `10.72.3.2`. Log baru menunjukkan `client=10.72.1.2` (Alpha) dan IP proxy masing-masing. [Skrip](02_Scripts_Per_Soal/Soal_14/) · [Penjelasan](docs/14-real-client-ip.md).

![IP asli Vault](04_Dokumentasi/assets/14-vault-real-ip.png)

![IP asli Core](04_Dokumentasi/assets/14-core-real-ip.png)

## 15. Eternal dan Orion

Penny melayani `/eternal/` menggunakan PHP lokal. Abbey melayani `/orion/` sebagai HTML statis dan menolak `/orion/uji.php` dengan HTTP 403. Pengujian Alpha menghasilkan HTTP 200 untuk kedua halaman utama. [Skrip](02_Scripts_Per_Soal/Soal_15/) · [Penjelasan](docs/15-eternal-orion.md).

![Uji Eternal dan Orion](04_Dokumentasi/assets/15-eternal-orion.png)

## 16. Benchmark

Jude melaporkan `ab -n 250 -c 10` pada `www.k17.com` dan `static.k17.com`. Keluaran lengkap ApacheBench belum diterima, jadi angka performa, keberhasilan, dan pemerataan beban belum dinyatakan. [Skrip rekonstruksi perintah](02_Scripts_Per_Soal/Soal_16/). **Bukti:** `16-benchmark.png` dan keluaran teks asli dari Jude masih diperlukan.

## 17. TXT Record Klien

Skrip Prab menambah TXT berisi nama untuk Alpha, Beta, Gamma, Delta, dan Epsilon. Hasil query setelah perubahan dan serial final belum diterima. [Skrip](02_Scripts_Per_Soal/Soal_17/). **Bukti:** `17-txt-klien.png` perlu ditambahkan.

## 18. TTL dan Caching DNS

Laporan Jude menjelaskan percobaan perubahan alamat Abbey sementara ke `10.72.3.99` dengan TTL 15 detik dan pemulihan ke `10.72.3.2`. `simulasi-18.sh` yang diterima berisi rencana tiga fase untuk `cachetest.k17.com`; keluaran nyata dan jalur resolver pengujian belum ada. [Skrip](02_Scripts_Per_Soal/Soal_18/). **Bukti:** `18-cache-awal.png`, `18-cache-sebelum-expired.png`, `18-cache-sesudah-expired.png` perlu ditambahkan.

## 19. CNAME Eksternal

Skrip Prab menambah `outbound.k17.com` sebagai CNAME ke `http.badssl.com.`. Hasil `dig` dan HTTP dari Alpha belum diterima dalam paket. [Skrip](02_Scripts_Per_Soal/Soal_19/). **Bukti:** `19-cname-eksternal.png` perlu ditambahkan.

## 20. Pemulihan dan Autostart

Laporan Jude menyatakan Abbey dikembalikan ke `10.72.3.2` dan beberapa `rc.local` ditulis untuk DNS serta NAT. Ekspor GNS3 tidak membawa konfigurasi aktif `/etc/bind`, `/etc/apache2`, atau `/etc/nginx`; bukti pemulihan sesudah impor/restart belum diterima. Karena itu autostart seluruh layanan belum dapat disimpulkan. [Skrip terkait](02_Scripts_Per_Soal/Soal_20/). **Bukti:** `20-pemulihan.png` perlu menampilkan pemeriksaan DNS, NAT, dan HTTP setelah restart.

## Kesimpulan

Topologi, skrip, dan hasil uji layanan web nomor 9–15 telah diarsipkan. Bagian DNS memiliki skrip Prab dan Tedd beserta bukti resolusi awal. Pengujian akhir nomor 16–20 dan pemulihan proyek setelah impor masih perlu dilengkapi sebelum menyatakan seluruh praktikum berhasil.
