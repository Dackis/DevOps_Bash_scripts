#!/bin/bash

cpu_threshold=70
log_file="./cpu_usage.log"


if [ ! -f "$log_file" ]; then
    touch "$log_file"
fi


current_time=$(date +"%Y-%m-%d %H:%M:%S")
high_cpu_processes=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | awk -v threshold="$cpu_threshold" '$5+0 > threshold {print "PID: "$1" CPU: "$5" CMD: "$3}')

echo "$high_cpu_processes"

if [ ! -z "$high_cpu_processes" ]; then
    echo "$current_time - ALERT: High CPU usage detected!" >> "$log_file"
    echo "$high_cpu_processes" >> "$log_file"
else
    echo "$current_time - No high CPU usage detected." >> "$log_file"
fi