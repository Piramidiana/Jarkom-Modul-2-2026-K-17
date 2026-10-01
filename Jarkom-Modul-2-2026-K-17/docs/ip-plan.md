# Rencana IP The Mesh — K-17

Prefix internal kelompok: `10.72.x.x`. Mask setiap cabang `/24` (`255.255.255.0`). DNS internal aktif: Prab `10.72.5.2` dan Tedd `10.72.5.3`. Resolver `192.168.122.1` pernah dipakai saat instalasi. Tabel merangkum alamat dan pengujian yang telah dikirim; bukan pemeriksaan langsung keadaan node saat pengumpulan.

| Cabang / switch | Node | Interface | IP/prefix | Gateway | Status |
| --- | --- | --- | --- | --- | --- |
| WAN NAT1 | rootkit | eth0 | 192.168.122.237/24 (terakhir teramati; dapat berubah) | 192.168.122.1 | Teruji internet |
| Operator | rootkit | eth1 | 10.72.1.1/24 | — | Teruji |
| Operator | Alpha | eth0 | 10.72.1.2/24 | 10.72.1.1 | Teruji internet dan DNS |
| Operator | Beta | eth0 | 10.72.1.3/24 | 10.72.1.1 | Teruji gateway dan internet |
| Operator | Gamma | eth0 | 10.72.1.4/24 | 10.72.1.1 | Teruji gateway dan internet |
| Divisi kedua | rootkit | eth2 | 10.72.2.1/24 | — | Terpasang |
| Divisi kedua | Delta | eth0 | 10.72.2.2/24 | 10.72.2.1 | Teruji gateway, internet, dan routing ke Alpha |
| Divisi kedua | Epsilon | eth0 | 10.72.2.3/24 | 10.72.2.1 | Teruji gateway dan internet |
| Proxy statis | rootkit | eth3 | 10.72.3.1/24 | — | Terpasang |
| Proxy statis | Abbey | eth0 | 10.72.3.2/24 | 10.72.3.1 | Teruji gateway dan internet |
| Proxy dinamis | rootkit | eth4 | 10.72.4.1/24 | — | Terpasang |
| Proxy dinamis | Penny | eth0 | 10.72.4.2/24 | 10.72.4.1 | Teruji gateway dan internet |
| DNS dan web | rootkit | eth5 | 10.72.5.1/24 | — | Terpasang |
| DNS dan web | Prab (DNS master) | eth0 | 10.72.5.2/24 | 10.72.5.1 | Teruji gateway dan internet |
| DNS dan web | Tedd (DNS slave) | eth0 | 10.72.5.3/24 | 10.72.5.1 | Teruji gateway dan internet |
| DNS dan web | Obladi (web statis) | eth0 | 10.72.5.4/24 | 10.72.5.1 | Teruji gateway dan internet |
| DNS dan web | Desmond (web statis) | eth0 | 10.72.5.5/24 | 10.72.5.1 | Teruji gateway dan internet |
| DNS dan web | Oblada (web dinamis) | eth0 | 10.72.5.6/24 | 10.72.5.1 | Teruji gateway, internet, dan web dinamis |
| DNS dan web | Molly (web dinamis) | eth0 | 10.72.5.7/24 | 10.72.5.1 | Teruji gateway, internet, dan web dinamis |

Domain kerja yang dipakai dan teruji: `k17.com`. Gateway klien harus memakai IP router pada subnetnya, bukan IP klien sendiri.
