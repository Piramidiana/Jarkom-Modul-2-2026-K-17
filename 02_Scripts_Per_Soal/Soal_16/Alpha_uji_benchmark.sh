#!/bin/sh
# Direkonstruksi dari perintah pada laporan Jude. Hasil uji belum diterima.
set -e
command -v ab >/dev/null || { echo 'ApacheBench (ab) belum tersedia di node ini' >&2; exit 1; }
ab -n 250 -c 10 http://www.k17.com/
ab -n 250 -c 10 http://static.k17.com/
