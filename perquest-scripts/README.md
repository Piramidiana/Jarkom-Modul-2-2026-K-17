# Skrip per soal

Skrip sudah disalin ke `../02_Scripts_Per_Soal/Soal_XX/` mengikuti format Modul 1, dengan awalan nama node. Tabel ini mencatat asalnya. Skrip asli berada di `../nodes/<nama-node>/`; menyalin berkas ke folder soal tidak berarti aman menjalankan ulang skrip yang menimpa konfigurasi DNS atau me-restart layanan.

| Nomor | Skrip yang berkaitan dan telah diterima |
| --- | --- |
| 1–3 | `nodes/rootkit/setup-rootkit-network.sh`, `setup-rootkit-nat.sh`, `rootkit-hostname.sh`; `setup-network.sh` dan `node-init.sh` pada node klien yang diterima |
| 4–8 | Tahap 1–5 Prab lengkap di `nodes/prab/`, termasuk 4b dan 4c; tahap 1–3 Tedd di `nodes/tedd/`; zona aktif final menunggu |
| 9 | `nodes/obladi/` dan `nodes/desmond/` (web dan jaringan) |
| 10 | `nodes/oblada/` dan `nodes/molly/` (web dinamis dan jaringan) |
| 11 | `nodes/penny/configure-penny-proxy.sh`, `nodes/abbey/configure-abbey-proxy.sh` |
| 12 | Skrip proxy Penny dan pembuatan akun interaktif (lihat `nodes/penny/README.md`) |
| 13 | `nodes/penny/configure-penny-redirect.sh`, `nodes/abbey/configure-abbey-redirect.sh` |
| 14 | `nodes/obladi/configure-obladi-realip.sh`, `nodes/desmond/configure-desmond-realip.sh`, `nodes/oblada/configure-oblada-realip.sh`, `nodes/molly/configure-molly-realip.sh` |
| 15 | `nodes/penny/create-penny-eternal.sh`, `configure-penny-eternal.sh`, `nodes/abbey/create-abbey-orion.sh`, `configure-abbey-proxy.sh` |
| 16–20 | `nodes/prab/simulasi-18.sh` baru berisi rancangan uji nomor 18; tunggu berkas dan bukti final Jude serta hasil uji bersama nomor 20 |

Skrip-skrip nomor 11–15 yang aktif adalah kondisi akhir setelah semua perubahan; penjelasan tiap nomor ada pada laporan. Soal 16 memuat skrip yang direkonstruksi dari perintah Jude dan belum ada hasil benchmark. Nomor 20 hanya memuat sebagian skrip pemulihan, tanpa bukti autostart penuh.
