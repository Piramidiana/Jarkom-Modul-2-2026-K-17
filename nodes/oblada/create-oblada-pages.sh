#!/bin/sh
set -e
mkdir -p /var/www/oblada

cat > /var/www/oblada/index.php <<'PHP'
<?php $node = htmlspecialchars(gethostname(), ENT_QUOTES, 'UTF-8'); ?>
<!doctype html>
<html lang="id">
<head><meta charset="utf-8"><title>Beranda Core</title></head>
<body>
  <h1>Beranda Core</h1>
  <p>Dilayani oleh: <?= $node ?></p>
  <a href="/profil">Lihat profil</a>
</body>
</html>
PHP

cat > /var/www/oblada/profil.php <<'PHP'
<?php $node = htmlspecialchars(gethostname(), ENT_QUOTES, 'UTF-8'); ?>
<!doctype html>
<html lang="id">
<head><meta charset="utf-8"><title>Profil Core</title></head>
<body>
  <h1>Profil Core</h1>
  <p>Dilayani oleh: <?= $node ?></p>
  <a href="/">Kembali ke beranda</a>
</body>
</html>
PHP
