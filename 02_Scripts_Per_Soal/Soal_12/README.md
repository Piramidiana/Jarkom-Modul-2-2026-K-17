# Soal 12 — Basic Auth Penny

Salinan skrip yang dikirim dari console node. Awalan nama file menunjukkan node tempat skrip berada.

Beberapa skrip memuat keadaan **final** sesudah soal berikutnya, dan ada yang digunakan di lebih dari satu soal. Jangan menjalankan semua salinan ini berurutan; tahap DNS tertentu menimpa zona dan beberapa skrip me-restart layanan.

- `Penny_configure-penny-proxy.sh` ← `nodes/penny/configure-penny-proxy.sh`
- Pembuatan berkas password `/etc/apache2/auth/penny-users` dilakukan interaktif lewat `htpasswd -cB ... prabs`; password tidak disimpan dalam repositori.
