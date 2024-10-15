#!/bin/bash

# ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | grep "nginx: master"


mem_threshold=1
cpu_threshold=70
log=monitor.log

if [  ! -f $log ]; then
    touch $log
fi

ps -eo pid,ppid,rss,%cpu,cmd --sort=-%cpu | grep "nginx: master process" | grep -v grep | while read -r pid ppid rss cpu cmd; do
    
    mem_mb=$(echo "scale=2; $rss/1024" | bc)

    if (( $(echo "scale=2; $mem_mb > $mem_threshold" | bc -l) || $(echo "scale=2; $cpu > $cpu_threshold" | bc -l ) )); then
    echo "---------------ALERT------------------------------"
    echo "Memory or CPU for NGINX service reached threshold"
    echo "Memory: $mem_mb - Threshold: $mem_threshold"
    echo "CPU: $cpu - Threshold: $cpu_threshold"
    echo "Restarting service NGINX"
    sudo systemctl restart nginx
        if systemctl is-active nginx --quiet ; then
        echo "Service NGINX restarted succesfully"
        fi
    fi
done