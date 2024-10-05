#!/bin/bash

df_output=$(df -h)
c_percentage=$(echo "$df_output" | awk '/C:/ { print $5 }')
d_percentage=$(echo "$df_output" | awk '/D:/ { print $5 }')
email=evaldas.samavicius@gmail.com


#------threshold-----------
threshold=60

#----GET DISK C used space---------
c_percentage=$(echo "$df_output" | awk '/C:/ { print $5 }')
usage_c=$(echo $c_percentage | tr -d '%')
echo $usage_c

#----GET DISK D used space---------
d_percentage=$(echo "$df_output" | awk '/D:/ { print $5 }')
usage_d=$(echo $d_percentage | tr -d '%')
echo $usage_d

#------LOG FILE-----
if [ ! -d ./log/ ]; then
    echo "creating log folder"
    mkdir log
    echo "log folder created"
fi

if [ ! -f ./log/disk_space_monitor_log.log ]; then
    touch ./log/disk_space_monitor_log.log
    echo "log file created"
fi



#------CHECK usage of disk C----------------
if [ $usage_c -gt $threshold ]; then 
    alert_C=$(cat <<EOF
$(date +"%Y-%m-%d %H:%M:%S") - ALERT!!! Disk C using $usage_c% (more than $threshold%)
$(date +"%Y-%m-%d %H:%M:%S") - Sending alert to $email
EOF
    )
    echo "$alert_C" >> ./log/disk_space_monitor_log.log
    echo "$alert_C" | mail -s "ALERT!!!! DISK C is over $threshold%" $email
    else
    echo " $(date +"%Y-%m-%d %H:%M:%S") - Disk C is using "$usage_c"% of disk space" >> ./log/disk_space_monitor_log.log
fi

#-------CHECK usage of disk D--------------

if [ $usage_d -gt $threshold ]; then
    alert_D=$(cat <<EOF
$(date +"%Y-%m-%d %H:%M:%S") - ALERT!!! Disk D using $usage_d% (more than $threshold%)
$(date +"%Y-%m-%d %H:%M:%S") - Sending alert to $email
EOF
    )
    echo "$alert_D" >> ./log/disk_space_monitor_log.log
    echo "$alert_D" | mail -s "ALERT!!!! DISK D is over $threshold%" $email
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Disk D is using "$usage_d"% of disk space" >> ./log/disk_space_monitor_log.log
fi
