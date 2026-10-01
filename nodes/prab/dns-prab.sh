#!/bin/bash
for i in 1 2 3 4 4b 4c 5; do bash /root/dns-prab-$i.sh || { echo "[X] gagal di bagian $i"; exit 1; }; done
