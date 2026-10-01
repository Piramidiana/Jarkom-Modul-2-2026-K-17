# Praktikum Jarkom Modul 2 — K-17

## Anggota

**Domain:** `k17.com` · **Prefix internal:** `10.72.x.x`, subnet `/24` pada setiap cabang.

| Anggota | NRP | Bagian yang dikerjakan |
| --- | --- | --- |
| Dian Piramidiana Rachmatika | 5027251031 | 1–3 dan 9–15, termasuk nomor 14 |
| Jude Athala Yazid Sari | 5027251098 | 4–8 dan 16–19; laporan Jude juga menyatakan pengerjaan 20 |

## Laporan

[Laporan_Modul_2_K17.md](Laporan_Modul_2_K17.md) disusun menurut nomor 1–20, seperti format pengumpulan Modul 1.

## Isi pengumpulan

- [Laporan praktikum](Laporan_Modul_2_K17.md): uraian per nomor dan bukti.
- [01_Project_GNS3](01_Project_GNS3/): ekspor proyek GNS3.
- [02_Scripts_Per_Soal](02_Scripts_Per_Soal/): skrip sesuai nomor soal; awalan nama berkas menunjukkan node.
- [04_Dokumentasi/assets](04_Dokumentasi/assets/): screenshot yang sudah diterima.
- [Tabel IP](docs/ip-plan.md): alamat, gateway, dan peran node.
- [Dokumentasi konfigurasi](docs/): tahapan web nomor 9–15. [Bukti gambar](assets/) mengikuti pola repo contoh.
- [Skrip per node](nodes/README.md): salinan sumber untuk memeriksa asal skrip per soal.
- [Catatan ekspor GNS3](gns3/README.md): isi dan batasan ekspor.
- [Daftar kelengkapan](KELENGKAPAN.md): berkas dan bukti yang belum diterima.

**Status paket: dokumentasi pengumpulan yang masih perlu bukti tambahan.** Skrip dari Rootkit, Penny, Abbey, Obladi, Desmond, Oblada, Molly, Prab, dan Tedd telah diarsipkan per node dan dipetakan per soal. Skrip benchmark nomor 16 adalah rekonstruksi dari perintah dalam laporan Jude, bukan salinan asli. Ekspor GNS3 telah disimpan, tetapi tidak menyertakan konfigurasi aktif di `/etc/bind`, `/etc/apache2`, dan `/etc/nginx`. Bukti akhir nomor 16–20 dan uji pemulihan belum tersedia. Rincian ada pada [daftar kelengkapan](KELENGKAPAN.md).

## Topologi layanan

Rootkit menghubungkan lima subnet melalui eth1–eth5; eth0 menuju NAT GNS3. Prab/Tedd menyediakan DNS. Penny menjalankan Apache dan menjadi gerbang `www.k17.com` ke Obladi/Desmond. Abbey menjalankan Nginx dan menjadi gerbang `static.k17.com` ke Oblada/Molly.

## Demo dari Alpha

```sh
nslookup obladi.k17.com 10.72.5.2
nslookup desmond.k17.com 10.72.5.3
for i in 1 2 3 4; do
  curl -sS http://www.k17.com/ | grep 'Repositori Statis'
done
for i in 1 2 3 4 5 6; do
  curl -sS http://static.k17.com/profil | grep 'Dilayani oleh'
done
curl -sS -o /dev/null -w 'Admin tanpa login: HTTP %{http_code}\n' http://www.k17.com/admin/
curl -sS -u prabs -i http://www.k17.com/admin/
curl -sS -i http://www.k17.com/eternal/
curl -sS -i http://static.k17.com/orion/
curl -sS -o /dev/null -w 'Orion PHP: HTTP %{http_code}\n' http://static.k17.com/orion/uji.php
```

Masukkan password `prabs` secara interaktif. Hasil yang telah teramati: respons dua backend, admin 401 tanpa login dan 200 dengan login, Eternal/Orion 200, uji PHP Orion 403. Ulangi sesudah restart untuk bukti nomor 20.
