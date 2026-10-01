#!/bin/bash
echo "=== FASE 1: QUERY PERTAMA ==="
dig @127.0.0.1 cachetest.k17.com +short
echo "-> SCREENSHOT INI SEBAGAI BUKTI AWAL (IP 1.1.1.1)"
echo "-> Lanjut tekan ENTER di terminal Prab!"
echo ""

read -p "[Tekan ENTER] jika Prab SUDAH MENGUBAH IP jadi 2.2.2.2..."
echo "=== FASE 2: UJI CACHE (MOMEN KRUSIAL) ==="
dig @127.0.0.1 cachetest.k17.com +short
echo "-> SCREENSHOT INI! Walau di Prab sudah 2.2.2.2, di sini harusnya MASIH 1.1.1.1 karena cache."
echo ""

echo "Menunggu 35 detik agar cache expired... (jangan di-cancel)"
sleep 35
echo "=== FASE 3: UJI CACHE KEDALUWARSA ==="
dig @127.0.0.1 cachetest.k17.com +short
echo "-> SCREENSHOT INI! Sekarang harusnya berubah jadi 2.2.2.2."
echo "-> Lanjut tekan ENTER di terminal Prab untuk pembersihan!"
