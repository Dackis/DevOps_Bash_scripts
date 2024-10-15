#!/bin/bash

cpu_usage () {
    local cpu_threshold=${1:-0.02}
    local total_cpu_usage=$(cat /proc/stat | grep cpu | tail -1 | awk '{printf "%.2f", 100 - ($5 * 100) / ($2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10)}')
    echo "Checking with cpu_threshold=$1"
    echo "cpu usage: $total_cpu_usage%"
    
    if [[ -z $total_cpu_usage ]]; then 
        return 2
    fi
    
    if (( $(echo "scale=2; $total_cpu_usage > $cpu_threshold"| bc -l ))); then
        return 1
    else
        return 0
    fi

}

cpu_usage $1
result=$?

if [[ $result -eq 2 ]]; then
    echo "An error occurred while retrieving CPU usage."
elif [[ $result -eq 1 ]]; then
    echo "CPU usage exceeded the specified threshold!"
elif [[ $result -eq 0 ]]; then
    echo "CPU usage is within normal limits."
fi

case $? in 
    0)
        echo "Disk usage is within normal limits."
        ;;
    1)
        echo "Warning: Disk usage has exceeded the threshold!"
        ;;
    2)
        echo "Error: Unable to retrieve disk usage information."
        ;;
    *)
        echo "Unexpected error."
        ;;
esac