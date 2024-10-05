#!/bin/bash

service=cron # $1 
date=$(date +%Y.%m.%d+%H%M%S)
service_log=service_log.log

if [ ! -f $service_log ]; then
touch $service_log
fi

if systemctl is-active $service --quiet; then
echo "INFORMATION Service; $service running - $date">>$service_log
else
echo "service is not running... RESTARTING..."
sudo systemctl restart $service
echo "ALERT service: $service is not running. RESTARTING at $date">>$service_log
echo "ALERT service: $service is not running. RESTARTING at $date" | mail -s "Service not running" evaldas.samavicius@gmail.com

    if systemctl is-active $service --quiet; then
    echo "ALERT: Service: $service was not running, and has been restarted succesfully">>$service_log
    else
    echo "CRITICAL: Service: $service Failed to restart at $date">>$service_log
    echo "CRITICAL: Failed to restart $service at $date" | mail -s "Service Restart Failed" evaldas.samavicius@gmail.com
    fi
fi