#!/bin/bash


Disk_usage_threshold=40
network_threshold=0.08

while read -r device kb_read kb_write; do

    # echo "Device: $device"
    # echo "kB_read/s: $kb_read"
    # echo "kB_wrtn/s: $kb_write"

    if (( $(echo "$kb_read > $Disk_usage_threshold" | bc -l) )); then
    echo $device
    echo "$device read exceeded maximum threshold"
    fi

     if (( $(echo "$kb_write > $Disk_usage_threshold" | bc -l) )); then
    echo $device
    echo "$device write exceeded maximum threshold"
    fi
done < <(iostat | awk '/Device/{flag=1; next} flag && $1 ~ /^sd/ {print $1, $3, $4}')

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
        echo "WARNING: Eth0 excceded download $kb_in threshold"
    fi

done