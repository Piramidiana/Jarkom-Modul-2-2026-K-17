#!/bin/bash
for i in 1 2 3; do bash /root/dns-tedd-$i.sh || { echo "[X] gagal di bagian $i"; exit 1; }; done
