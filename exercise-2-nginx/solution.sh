#!/bin/bash

# Pastikan folder output ada
mkdir -p output

# Definisikan file laporan utama
REPORT="output/log_analysis_report.txt"

# Kosongkan file laporan lama jika ada, lalu isi header
echo "==================================================" > $REPORT
echo "   LAPORAN ANALISIS LOG NGINX (EXERCISE 2)       " >> $REPORT
echo "==================================================" >> $REPORT

# Soal 1: Top 10 IP dengan request terbanyak
echo -e "\n=== Soal 1: Top 10 IP ===" >> $REPORT
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -n 10 >> $REPORT

# Soal 2: Error rate (4xx + 5xx) per jam
echo -e "\n=== Soal 2: Error Rate Per Jam ===" >> $REPORT
echo -e "Jam\tTotal\tError\tRate%" >> $REPORT
awk '{
    match($4, /:([0-9]{2}):[0-9]{2}:/, h);
    jam=h[1];
    status=$9;
    total[jam]++;
    if(status >= 400) error[jam]++;
} END {
    for(j in total) {
        err = error[j] ? error[j] : 0;
        rate = (err / total[j]) * 100;
        printf "%s\t%d\t%d\t%.2f%%\n", j, total[j], err, rate
    }
}' access.log | sort >> $REPORT

# Soal 3: Suspected brute force (>50 kali ke /login atau /admin)
echo -e "\n=== Soal 3: Suspected Brute Force ===" >> $REPORT
awk '$7 ~ /(\/login|\/admin)/ {print $1}' access.log | sort | uniq -c | awk '$1 > 50 {print "IP: " $2 " - Request: " $1}' >> $REPORT

# Soal 4: Endpoint paling lambat (Top 10 rata-rata response time)
echo -e "\n=== Soal 4: Top 10 Endpoint Paling Lambat ===" >> $REPORT
awk '{sum[$7]+=$NF; cnt[$7]++} END {for(e in sum) print e, sum[e]/cnt[e]}' access.log | sort -k2 -nr | head -n 10 >> $REPORT

# Soal 5: Total bytes transferred ke MB
echo -e "\n=== Soal 5: Total Bytes Transferred ===" >> $REPORT
awk '{sum+=$10} END {printf "Total: %.2f MB\n", sum/1024/1024}' access.log >> $REPORT

# Print isi laporan ke layar terminal agar user tetap bisa melihat hasilnya langsung
cat $REPORT
