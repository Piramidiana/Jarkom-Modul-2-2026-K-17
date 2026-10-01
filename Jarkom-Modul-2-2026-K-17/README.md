# Praktikum Jarkom Modul 2 — K-17

## Anggota

**Domain:** `k17.com` · **Prefix internal:** `10.72.x.x`, subnet `/24` pada setiap cabang.

| Anggota | NRP | Bagian yang dikerjakan |
| --- | --- | --- |
| Dian Piramidiana Rachmatika | 5027251031 | 1–3 dan 9–15, termasuk nomor 14 |
| Jude Athala Yazid Sari | 5027251098 | 4–8 dan 16–19; laporan Jude juga menyatakan pengerjaan 20 |

## Laporan

[Laporan nomor 1–20, hasil dan screenshot](laporan.md) disusun sesuai nomor soal.

## Isi pengumpulan

- [Laporan praktikum](laporan.md): ringkasan hasil dan tautan bukti.
- [Tabel IP](docs/ip-plan.md): alamat, gateway, dan peran node.
- [Dokumentasi konfigurasi](docs/): tahapan web nomor 9–15. [Bukti gambar](assets/) mengikuti pola repo contoh.
- [Skrip per node](nodes/README.md) dan [peta per soal](perquest-scripts/README.md): lokasi dan daftar yang perlu dilengkapi.
- [Proyek GNS3](gns3/README.md): tempat ekspor proyek final.
- [Daftar kelengkapan](KELENGKAPAN.md): berkas dan bukti yang belum diterima.

**Status paket: dokumentasi awal pengumpulan.** Hasil nomor 1–3 dan 9–15 telah terlihat pada keluaran terminal praktikum. DNS master/slave dan resolusi beberapa hostname juga pernah diuji. Skrip Rootkit, Penny, Abbey, Obladi, Desmond, Oblada, Molly, Prab, dan Tedd serta ekspor GNS3 telah disimpan; bukti akhir Jude nomor 16–20 belum tersedia dalam paket ini. Ekspor GNS3 tidak menyertakan konfigurasi aktif di `/etc/bind`, `/etc/apache2`, dan `/etc/nginx`, sehingga perlu diuji pemulihannya dari skrip. Penulisan `rc.local` saja belum menjadi bukti bahwa semua layanan pulih setelah restart.

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
