#!/bin/bash

log_file="./access.log"
num_entries=1000  # Number of log entries to generate
statuses=("200" "404" "500")  # HTTP status codes to simulate
ips=("192.168.1.10" "192.168.1.20" "10.0.0.1")  # IPs for variety

# # Remove old log file if it exists
 [ -f "$log_file" ] && rm "$log_file"

# Generate random log entries
for i in $(seq 1 $num_entries); do
    # Change the timestamp format to use numerical months: %d/%m/%Y
    timestamp=$(date -d "1 day ago" +"%Y/%m/%d:%H:%M:%S %z")
    ip=${ips[$RANDOM % ${#ips[@]}]}
    status=${statuses[$RANDOM % ${#statuses[@]}]}
    size=$((RANDOM % 5000 + 500))
    
    echo "$ip - - [$timestamp] \"GET /index.html HTTP/1.1\" $status $size" >> "$log_file"
done

echo "Log file generated: $log_file"
