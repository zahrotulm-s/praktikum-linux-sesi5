
# Laporan Praktikum Sistem Operasi - Sesi 5
## Pemrosesan Data Berbasis Teks dan Manajemen File Jaringan di Lingkungan Linux

---

## 1. Identitas Mahasiswa
* **Nama:** Zahrotul M. S.
* **Username GitHub:** zahrotulm-s
* **Mata Kuliah:** Praktikum Sistem Operasi (Sesi 5)

---

## 2. Dokumentasi Tugas Persiapan 

### 1) Verifikasi Sesi Koneksi SSH Berhasil 
Servis SSH Daemon (`sshd`) telah dikonfigurasi dan diverifikasi berjalan aktif pada port jaringan sistem. Autentikasi remote access dari Host OS (Windows LENOVO) menuju Guest OS (Linux Box) melalui secure port redirection berhasil dilakukan secara stabil.
*(Bukti visual berupa tangkapan layar/screenshot login "Welcome to Ubuntu" telah dilampirkan pada berkas laporan utama).*
<img width="960" height="504" alt="WindowsTerminal_wZAZyAtudY" src="https://github.com/user-attachments/assets/1ff066a0-6ef0-4656-9b6c-cabb51bba2ea" />

### 2) Output Proses Sinkronisasi File Menggunakan Rsync 
Proses manajemen file jaringan untuk pemindahan dan pencadangan data mentah `data.csv` (Exercise 1) dieksekusi menggunakan utilitas `rsync` dengan parameter `-avz --progress`. Protokol ini memastikan transfer data berjalan secara asinkron, efisien, serta menampilkan metrik kecepatan transfer secara transparan:

```text
mupicans@mupi:~$ rsync -avz --progress ~/praktikum-linux-sesi5/exercise-1-csv/data.csv /tmp/data_output.csv
sending incremental file list
data.csv
         68.492 100%    3,10MB/s    0:00:00 (xfr#1, to-chk=0/1)

sent 22.928 bytes  received 35 bytes  45.926,00 bytes/sec
total size is 68.492  speedup is 2,98

```

### 3) Verifikasi Integritas Data via Checksum SHA-256 

Guna menjamin keabsahan dan keutuhan data (*data integrity*) agar tidak mengalami kerusakan file (*file corruption*) selama proses pemindahan lintas platform (Windows dan Linux), dilakukan pengujian nilai kode hash SHA-256 pada masing-masing sistem operasi.

* **Hasil Checksum pada Sisi Linux Box (Ubuntu):**

```text
mupicans@mupi:~$ sha256sum ~/praktikum-linux-sesi5/exercise-1-csv/data.csv
c2f544f2ec2349ac67fde5e708df8adc19e573129dc1c32b46f1ca2b9ff9eadf
/home/mupicans/praktikum-linux-sesi5/exercise-1-csv/data.csv

```

* **Hasil Checksum pada Sisi Host OS (Windows via CertUtil):**

```text
PS C:\Users\LENOVO> CertUtil -hashfile C:\Users\LENOVO\Downloads\data.csv SHA256
SHA256 hash of C:\Users\LENOVO\Downloads\data.csv:
c2f544f2ec2349ac67fde5e708df8adc19e573129dc1c32b46f1ca2b9ff9eadf
CertUtil: -hashfile command completed successfully.

```

> **Analisis Kesimpulan:** Nilai kalkulasi algoritma kriptografi SHA-256 pada kedua sistem operasi menunjukkan hasil yang **IDENTIK** (`c2f544f2...9eadf`). Hal ini membuktikan berkas data telah tersinkronisasi 100% utuh tanpa adanya modifikasi atau kehilangan bit data di dalam jaringan.

### 4) Catatan Teoretis: Komparasi Karakteristik SCP vs Rsync 

Berdasarkan tinjauan instruksi modul, berikut adalah analisis perbandingan mendalam mengenai penggunaan protokol SCP dan Rsync pada manajemen jaringan Linux:

* **SCP (Secure Copy Protocol)**
* **Kelebihan:** Sangat ringkas, instan, dan responsif saat menyalin berkas tunggal berukuran kecil antar-server karena memiliki overhead komputasi yang sangat rendah di awal sesi.
* **Kekurangan:** Tidak efisien untuk struktur direktori berskala besar. SCP tidak memiliki kemampuan untuk mendeteksi perbedaan data (*non-differential*) sehingga akan selalu melakukan *overwrite* total secara linear. Selain itu, SCP tidak mendukung fitur pelanjutan transfer jika koneksi terputus (*non-resumable*).


* **Rsync (Remote Synchronization)**
* **Kelebihan:** Mengandalkan algoritma *Delta Transfer* tingkat lanjut, di mana sistem hanya mengirimkan blok data atau baris kode yang mengalami perubahan saja (*differential update*). Mendukung fitur kompresi data dinamis (`-z`), visualisasi progres kerja (`--progress`), pemulihan sesi terputus (`--partial`), serta mampu mengunci kepemilikan metadata file asli (`-a`).
* **Kekurangan:** Memerlukan utilisasi memori RAM dan resource CPU yang sedikit lebih tinggi di awal proses pengiriman untuk melakukan komparasi *checksum* indeks file pada host sumber dan tujuan.



---

## 3. Ringkasan Hasil Eksekusi Pemrosesan Teks (Exercise 1 - 4)

### 📁 Exercise 1: Pembersihan CSV Data Customer

* **Fokus Tugas:** Otomatisasi standardisasi penulisan format penanggalan, koreksi kesalahan kapitalisasi teks nama (*case sensitivity correction*), dan klasifikasi status akun aktif.
* **Hasil di Folder `output/`:**
* `customer_clean.csv`: Database utama dengan format data dan struktur tanggal yang telah diseragamkan.
* `customer_active.csv`: Hasil penapisan (*filtering*) khusus customer berstatus aktif (*Active*).
* `typo_report.txt`: Dokumentasi log riwayat nama-nama entitas sebelum dilakukan perbaikan kapitalisasi.



### 📁 Exercise 2: Analisis Nginx Access Log

* **Fokus Tugas:** Audit berkas log *web server* untuk melacak intensitas trafik jaringan, mitigasi anomali serangan keamanan cyber, dan kalkulasi performa server.
* **Hasil di Folder `output/`:**
* `log_analysis_report.txt`: Laporan komprehensif terpadu yang memuat statistik Top 10 IP penyerang, tabel *Error Rate* (4xx/5xx) per jam, melacak anomali *Suspected Brute Force* pada gerbang login, kalkulasi performa *Slow Endpoints*, serta akumulasi total transfer data sistem dalam satuan Megabytes (MB).



### 📁 Exercise 3: Pemisahan Data JSON Ter-nested

* **Fokus Tugas:** Pelacakan data transaksi e-commerce bermasalah mengandalkan utilitas manipulasi berkas JSON (`jq`) untuk mengisolasi inkonsistensi nilai keuangan (*data mismatch*).
* **Hasil di Folder `output/`:**
* `mismatch-orders.json`: Berkas koleksi transaksi tidak valid di mana akumulasi riil dari (`quantity` $\times$ `price`) pada array items tidak seimbang dengan nilai atribut `total_order_amount`.



### 📁 Exercise 4: Migrasi & Deduplikasi Data Toko Online

* **Fokus Tugas:** Sinkronisasi silang antara database produk lama dan baru, mereduksi redundansi data duplikat (*data deduplication*), dan melakukan pembaruan entitas mutakhir mengandalkan parameter *timestamp* terbaru via perintah `sort`.
* **Hasil di Folder `output/`:**
* `produk_clean.csv`: Database produk final yang telah di-update secara mutakhir dan bersih dari data ganda. Laporan validasi nilai statistik (harga min/max/avg) beserta sebaran produk per kategori ditampilkan langsung melalui *Validation Report* pada *standard output* terminal.



---

*Catatan: Seluruh berkas otomatisasi script (`solution.sh` / `migrate.sh`), berkas log mentah, data instruksi AI (`prompt.txt`), serta seluruh struktur direktori keluaran telah tersinkronisasi secara penuh di dalam repository GitHub ini.*

