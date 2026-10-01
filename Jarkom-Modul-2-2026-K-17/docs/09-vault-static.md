# Nomor 9 — Backend statis Vault

Obladi (`10.72.5.4`) dan Desmond (`10.72.5.5`) memakai Apache pada Debian 13. DocumentRoot masing-masing `/var/www/obladi` dan `/var/www/desmond`. Halaman utama menampilkan identitas repositori, sedangkan `/arsip/` menampilkan daftar berkas melalui `Options +Indexes`.

DNS `obladi.k17.com` dan `desmond.k17.com` menjawab alamat masing-masing. Pengujian dari Alpha menghasilkan HTTP 200; daftar arsip memuat `catatan-obladi.txt` atau `catatan-desmond.txt`.

Konfigurasi final memakai alias `www.k17.com`, `penny.k17.com`, dan `vault.k17.com` untuk header Host yang diteruskan Penny. Nomor 14 menambahkan mod_remoteip dan format log IP asli.

![Uji hostname dan arsip Vault](../assets/09-vault-hostname-arsip.png)
