#!/bin/bash

mem_threshold=80
cpu_threshold=80
disk_threshold=80
network_threshold=0.08
log_file=./log/monitoring.log

if [ ! -f $log_file ]; then
    touch $log_file
fi

D_disk_used_space=$( df -h | awk '/D:/ {print $5}' | tr -d '%')

if [ $D_disk_used_space -gt $disk_threshold ]; then
    echo "ALERT" >> $log_file
    echo "Volume D exceed alert disk threshold - 95%" >> $log_file

fi

mem_usage=$( free -m | awk '/Mem:/ {print $3}')
mem_total=$( free -m | awk '/Mem:/ {print $2}')
 

mem_used=$(echo "scale=2; $mem_usage * 100 / $mem_total" | bc -l)


if (( $(echo "scale=2; $mem_used > $mem_threshold" | bc -l) )); then
    echo "ALERT" >> $log_file
    echo "Mem exceeded limit" >> $log_file
else
    echo "Memory stable" >> $log_file
fi

ifstat -i eth0 1 5 | while read -r line; do
    # Skip the headers or any unwanted lines, e.g., the interface and column names
    if [[ "$line" == *"eth0"* || "$line" == *"KB/s"* ]]; then
        continue
    fi
    
    # Extract the incoming and outgoing data (two columns) and store them in variables
    kb_in=$(echo "$line" | awk '{print $1}')
    kb_out=$(echo "$line" | awk '{print $2}')

    # Display or process the values

    if (( $(echo "$kb_in > $network_threshold" | bc -l) )); then
        echo "WARNING: Eth0 excceded download $kb_in threshold" >> $log_file
    else
        echo "Network is stable" >> $log_file
    fi
done

# cpu_usage=$(cat /proc/stat |grep cpu |tail -1|awk '{print ($5*100)/($2+$3+$4+$5+$6+$7+$8+$9+$10)}'|awk '{print "CPU Usage: " 100-$1}')

cpu_usage=$(cat /proc/stat | grep cpu | tail -1 | awk '{print 100 - ($5 * 100) / ($2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10)}')
echo "cpu: $cpu_usage"
if (( $(echo "$cpu_usage > $cpu_threshold" | bc -l) )); then
    echo "ALERT" >> $log_file
    echo "CPU usage exceeded alert limit" >> $log_file
else 
    echo "CPU is stable" >> $log_file
fi