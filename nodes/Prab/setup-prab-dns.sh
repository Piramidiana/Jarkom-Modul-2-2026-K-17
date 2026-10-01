#untuk prab.sh ini prompt generalnya semua node 
#!/bin/bash
DOMAIN="k17.com"
IP_PRAB="10.72.5.2"
IP_TEDD="10.72.5.3"
IP_PENNY="10.72.4.2"
IP_ABBEY="10.72.3.2"

# Asumsi IP Vault & Core (GANTI JIKA BEDA):
IP_OBLADI="10.72.6.2"; IP_DESMOND="10.72.6.3"
IP_OBLADA="10.72.7.2"; IP_MOLLY="10.72.7.3"

# 1. Konfigurasi Master & Forwarders (No. 4)
cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; };
    allow-query { any; };
    listen-on-v6 { any; };
};
EOF

# Deklarasi Zone Forward & Reverse (No. 4 & No. 8)
cat > /etc/bind/named.conf.local << EOF
zone "$DOMAIN" {
    type master;
    file "/etc/bind/db.$DOMAIN";
    allow-transfer { $IP_TEDD; };
    notify yes;
};
zone "4.72.10.in-addr.arpa" { type master; file "/etc/bind/db.10.72.4"; allow-transfer { $IP_TEDD; }; };
zone "3.72.10.in-addr.arpa" { type master; file "/etc/bind/db.10.72.3"; allow-transfer { $IP_TEDD; }; };
zone "6.72.10.in-addr.arpa" { type master; file "/etc/bind/db.10.72.6"; allow-transfer { $IP_TEDD; }; };
zone "7.72.10.in-addr.arpa" { type master; file "/etc/bind/db.10.72.7"; allow-transfer { $IP_TEDD; }; };
EOF

# 2. File Forward Zone Lengkap (No. 4, 5, 7, 17, 19)
cat > /etc/bind/db.$DOMAIN << EOF
\$TTL 30
@   IN  SOA prab.$DOMAIN. admin.$DOMAIN. ( 2026100501 30 10 60 30 )
@   IN  NS  prab.$DOMAIN.
@   IN  NS  tedd.$DOMAIN.
@   IN  A   $IP_PENNY       ; Apex record -> gerbang dinamis (No. 4)

; A Record DNS (No. 4)
prab    IN  A   $IP_PRAB
tedd    IN  A   $IP_TEDD

; A Record Klien & Web (No. 5)
alpha   IN  A   10.72.1.2
beta    IN  A   10.72.1.3
gamma   IN  A   10.72.1.4
delta   IN  A   10.72.2.2
epsilon IN  A   10.72.2.3
penny   IN  A   $IP_PENNY
abbey   IN  A   $IP_ABBEY
obladi  IN  A   $IP_OBLADI
desmond IN  A   $IP_DESMOND
oblada  IN  A   $IP_OBLADA
molly   IN  A   $IP_MOLLY

; Round-Robin & CNAME (No. 7 & 19)
vault   IN  A   $IP_OBLADI
vault   IN  A   $IP_DESMOND
core    IN  A   $IP_OBLADA
core    IN  A   $IP_MOLLY
www     IN  CNAME penny.$DOMAIN.
static  IN  CNAME abbey.$DOMAIN.
outbound IN CNAME http.badssl.com.

; TXT Record Identitas (No. 17)
alpha   IN  TXT "alpha"
beta    IN  TXT "beta"
gamma   IN  TXT "gamma"
delta   IN  TXT "delta"
epsilon IN  TXT "epsilon"
EOF

# 3. File Reverse Zone (No. 8)
cat > /etc/bind/db.10.72.4 << EOF
\$TTL 86400
@ IN SOA prab.$DOMAIN. admin.$DOMAIN. ( 1 86400 3600 604800 86400 )
@ IN NS prab.$DOMAIN.
2 IN PTR penny.$DOMAIN.
EOF

cat > /etc/bind/db.10.72.3 << EOF
\$TTL 86400
@ IN SOA prab.$DOMAIN. admin.$DOMAIN. ( 1 86400 3600 604800 86400 )
@ IN NS prab.$DOMAIN.
2 IN PTR abbey.$DOMAIN.
EOF

# (Lakukan hal yang sama untuk file .6 dan .7 jika diminta spesifik)

# 4. Autostart Service (No. 20)
if ! grep -q "named" /etc/network/interfaces; then
    echo "    up /usr/sbin/named -u bind" >> /etc/network/interfaces
fi

kill -9 \$(pidof named) 2>/dev/null; named -u bind
echo "[SUKSES] Prab (Master) terkonfigurasi menyeluruh!"