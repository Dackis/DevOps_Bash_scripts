#!/bin/bash

log=./log/my_app.log
monitor_log=./monitor.log
date=$(date +%Y-%m-%d+%H%M%S)
while read -r line; do

error_found=$(grep -iE "ERROR|CRITICAL|FATAL" "$log")

done <$log

#----check if monitor log exist-------
if [ ! -f $monitor_log ]; then
    touch $monitor_log
fi

#---check if line contains expressions(FATAL CRITICAL ERROR)-----
if [ ! -z "$error_found" ]; then
    echo "$date ALERT: error found in $monitor_log" >>$monitor_log
    echo "$error_found">>$monitor_log
else
    echo "$date no errors found in $monitor_log">>$monitor_log
fi