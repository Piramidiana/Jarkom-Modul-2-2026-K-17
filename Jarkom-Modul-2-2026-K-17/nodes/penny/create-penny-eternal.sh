#!/bin/sh
set -e

mkdir -p /var/www/eternal
cat > /var/www/eternal/index.php <<'PHP'
<!doctype html>
<html lang="id">
<head><meta charset="utf-8"><title>Eternal</title></head>
<body>
  <h1>Halaman Eternal K-17</h1>
  <p>PHP aktif di Penny, versi <?= htmlspecialchars(PHP_VERSION, ENT_QUOTES, 'UTF-8') ?></p>
</body>
</html>
PHP
