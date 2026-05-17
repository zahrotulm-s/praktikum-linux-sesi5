#!/bin/bash

# Soal 1: Hitung jumlah customer per status (Normalisasi ke lowercase)
echo "=== Soal 1: Jumlah Customer per Status ==="
awk -F, 'NR>1 {print tolower($6)}' data.csv | sort | uniq -c

# Soal 2: Konversi tanggal_daftar jadi ISO 8601 (yyyy-mm-dd)
echo -e "\n=== Soal 2: Konversi Tanggal ==="
sed -E 's|([0-9]{2})/([0-9]{2})/([0-9]{4})|\3-\2-\1|g' data.csv > output/data-normalized-date.csv
head -n 5 output/data-normalized-date.csv

# Soal 3: Ekstrak customer dengan email @gmail.com
awk -F, '$3 ~ /@gmail\.com/ {print}' data.csv > output/gmail-customers.csv
echo "Hasil filter Gmail sukses disimpan di folder output/"

# Soal 4: Hapus duplikat berdasarkan kolom email
awk -F, '!seen[$3]++' data.csv > output/cleaned-email.csv
echo "Hasil hapus duplikat email sukses disimpan di folder output/"

# Soal 5: Hitung customer yang namanya tidak title-case
echo -e "\n=== Soal 5: Nama Tidak Title-Case ==="
awk -F, 'NR>1 {print $2}' data.csv | awk '{
    is_title=1; 
    for(i=1;i<=NF;i++) {
        if(substr($i,1,1) !~ /[A-Z]/ || substr($i,2) ~ /[A-Z]/) is_title=0
    } 
    if(is_title==0) print $0
}' | wc -l
