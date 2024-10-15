#!/bin/bash

Disk_usage_threshold=80
cpu_usage_threshold=0.1
mem_threshold=3
log_file=usage.log
date=$(date +%Y-%m-%d+%H%M%S)
if [ ! -f $log_file ]; then
touch $log_file
fi

#----------------MONITOR DISK USAGE------------------

while read -r filesystem size use_percentage; do
use_percentage=$(echo $use_percentage | cut -d '%' -f 1)

if [[ $use_percentage -gt $Disk_usage_threshold ]] ; then
echo "DISK USAGE ALERT!!!">>$log_file
echo "ALERT">>$log_file
echo "$date - Filesystem $filesystem disk usage exceed threshold">>$log_file
echo "Filesystem - $filesystem , size - $size , disk usage (%) : $use_percentage , threshold - $Disk_usage_threshold">>$log_file
fi

done < <(df -h | awk '{print $1, $2, $5}')


#---------------MONITOR CPU Ussage---------------------

while read -r cpu cpu_usage; do

total_cpu_usage=$(echo "scale=4; 100 - $cpu_usage" | bc -l )

if (( $(echo "$total_cpu_usage > $cpu_usage_threshold" | bc -l) )); then
echo "CPU USAGE ALERT!!!">>$log_file
echo "$date CPU reached threshold: $cpu_usage_threshold">>$log_file
fi

done < <(mpstat | awk '/CPU/{flag=1; next}{print $3, $13}')


#---------------Monitor MEM usage--------------------

while read -r total mem_used; do

free_mem=$(echo "scale=2 ;$mem_used * 100 / $total" | bc -l )

if (( $(echo "$free_mem > $mem_threshold" |bc -l) )); then
echo "MEMORY ALERT!!!">>$log_file
echo "$date memory $free_mem  exceeded  threshold $mem_threshold">>$log_file
fi
done < <(free -m | awk '/Mem:/{print $2, $3}')