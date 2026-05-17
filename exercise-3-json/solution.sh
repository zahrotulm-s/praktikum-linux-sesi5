#!/bin/bash

# Pastikan folder output sudah terbuat
mkdir -p output

# Pastikan tool jq sudah terinstall di Ubuntu
if ! command -v jq &> /dev/null; then
    echo "Instalasi jq terlebih dahulu..."
    sudo apt update && sudo apt install -y jq
fi

echo "=================================================="
echo "   ANALISIS DATA JSON E-COMMERCE (EXERCISE 3)     "
echo "=================================================="

# Soal 1: Hitung total spending per customer dan urutkan Top 5 Terbesar
echo -e "\n=== Soal 1: Top 5 Spending Customers ==="
jq -r '.[] | {name: .customer_name, amount: .total_order_amount}' orders.json | \
jq -s 'group_by(.name) | map({name: .[0].name, total_spending: map(.amount) | add}) | sort_by(.total_spending) | reverse | .[:5]'

# Soal 2: Deteksi Bug / Mismatch Data (total_order_amount != hasil penjumlahan item)
echo -e "\n=== Soal 2: Laporan Transaksi Mismatch (Bug) ==="
echo -e "Order ID\tNama Customer\tAmount di JSON\tHitungan Asli"
echo -e "-------------------------------------------------------------"

jq -r '.[] | 
  .order_id as $id | 
  .customer_name as $name | 
  .total_order_amount as $json_amt | 
  (.items | map(.quantity * .price) | add) as $real_amt | 
  select($json_amt != $real_amt) | 
  "\($id)\t\($name)\t\($json_amt)\t\($real_amt)"' orders.json

# Soal 3: Ekstrak semua transaksi bermasalah ke folder output/
jq '[.[] | 
  .total_order_amount as $json_amt | 
  (.items | map(.quantity * .price) | add) as $real_amt | 
  select($json_amt != $real_amt)]' orders.json > output/mismatch-orders.json

echo -e "\n[SUKSES] Semua data transaksi yang bug telah disimpan di output/mismatch-orders.json"
