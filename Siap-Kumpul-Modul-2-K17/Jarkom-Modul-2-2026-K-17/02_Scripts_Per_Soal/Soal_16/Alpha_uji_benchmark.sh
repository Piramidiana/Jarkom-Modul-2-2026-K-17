#!/bin/sh
# Jalankan di Alpha setelah www dan static dapat diakses.
set -e
command -v ab >/dev/null || { echo 'ApacheBench belum terpasang' >&2; exit 1; }
ab -n 250 -c 10 http://www.k17.com/
ab -n 250 -c 10 http://static.k17.com/
