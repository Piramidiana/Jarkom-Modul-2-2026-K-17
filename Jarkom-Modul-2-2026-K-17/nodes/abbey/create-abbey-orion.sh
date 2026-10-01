#!/bin/sh
set -e

mkdir -p /var/www/orion

cat > /var/www/orion/index.html <<'HTML'
<!doctype html>
<html lang="id">
<head><meta charset="utf-8"><title>Orion</title></head>
<body>
  <h1>Halaman Statis Orion K-17</h1>
  <p>File ini dilayani langsung oleh Abbey.</p>
</body>
</html>
HTML

printf '%s\n' '<?php echo "PHP_DIEKSEKUSI"; ?>' > /var/www/orion/uji.php
