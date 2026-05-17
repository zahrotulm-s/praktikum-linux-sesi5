#!/bin/bash

# Pastikan folder output ada
mkdir -p output

# Soal 1: Top 10 IP dengan request terbanyak
echo "=== Soal 1: Top 10 IP ==="
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -n 10

# Soal 2: Error rate (4xx + 5xx) per jam
echo -e "\n=== Soal 2: Error Rate Per Jam ==="
echo -e "Jam\tTotal\tError\tRate%"
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
}' access.log | sort

# Soal 3: Suspected brute force (>50 kali ke /login atau /admin)
echo -e "\n=== Soal 3: Suspected Brute Force ==="
awk '$7 ~ /(\/login|\/admin)/ {print $1}' access.log | sort | uniq -c | awk '$1 > 50 {print "IP: " $2 " - Request: " $1}'

# Soal 4: Endpoint paling lambat (Top 10 rata-rata response time)
echo -e "\n=== Soal 4: Top 10 Endpoint Paling Lambat ==="
awk '{sum[$7]+=$NF; cnt[$7]++} END {for(e in sum) print e, sum[e]/cnt[e]}' access.log | sort -k2 -nr | head -n 10

# Soal 5: Total bytes transferred ke MB
echo -e "\n=== Soal 5: Total Bytes Transferred ==="
awk '{sum+=$10} END {printf "Total: %.2f MB\n", sum/1024/1024}' access.log

