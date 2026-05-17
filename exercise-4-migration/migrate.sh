#!/bin/bash

# Pastikan folder output terbuat
mkdir -p output

echo "=================================================="
echo "    PROSES MIGRASI & DEDUPLIKASI DATA (EXERCISE 4)"
echo "=================================================="

# 1. Menggabungkan kedua file CSV (abaikan header baris pertama dari file baru)
# Menggunakan hint sort dari modul: sort berdasarkan id_produk (kolom 1) lalu tanggal_input (kolom 6) secara reverse
cat produk_lama.csv <(tail -n +2 produk_baru.csv) | \
sort -t, -k1,1 -k6,6r | \
awk -F, '!seen[$1]++' > output/produk_clean.csv

echo -e "[SUKSES] Penggabungan & deduplikasi selesai!"
echo -e "Hasil akhir disimpan di: output/produk_clean.csv\n"

# 2. Membuat VALIDATION REPORT (Analisis Statistik Ringkas)
echo "=== VALIDATION REPORT ==="
echo "--------------------------------------------------"

# Hitung Total Produk Unik (Abaikan baris header)
total_produk=$(awk -F, 'NR>1 {print $1}' output/produk_clean.csv | wc -l)
echo "Total Produk Unik Setelah Migrasi: $total_produk"

# Hitung Harga Minimum, Maksimum, dan Rata-rata menggunakan AWK
awk -F, '
NR>1 {
    harga=$3;
    if (min=="") {min=max=harga};
    if (harga < min) min=harga;
    if (harga > max) max=harga;
    sum+=harga;
    count++;
} 
END {
    if (count > 0) {
        printf "Harga Produk Termurah          : Rp %.2f\n", min;
        printf "Harga Produk Termahal          : Rp %.2f\n", max;
        printf "Rata-rata Harga Produk         : Rp %.2f\n", sum/count;
    }
}' output/produk_clean.csv

# Hitung Distribusi Jumlah Produk per Kategori
echo -e "\nDistribusi Produk per Kategori:"
echo "----------------------------------"
awk -F, 'NR>1 {print $5}' output/produk_clean.csv | sort | uniq -c | awk '{printf "- %s: %s produk\n", $2, $1}'
