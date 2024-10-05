#!/bin/bash

log_file=./system.log
failed_login_count=0
declare -A unique_ip_address
declare -A formatted_timestamp

#------read line by line--------

while IFS= read -r line; do

#----------    extract "failed login" -----------
    attempt=$(echo $line | awk '/failed login/')

if [[ -n $attempt ]]; then
    (( failed_login_count++ ))
    

#-----------extract IP ADDRESS----------------
    
    ip_address=$(echo $attempt | awk '{match($0, /([0-9]{1,3}\.){3}[0-9]{1,3}/); print substr($0, RSTART, RLENGTH)}' ) 
    if [[ -n $ip_address ]]; then
        if [[ -z ${unique_ip_address[$ip_address]} ]]; then
        unique_ip_address[$ip_address]=$ip_address
        fi
    
    fi
    
#-----------extract date-------------
    
    timestamp=$(echo "$attempt" | awk '{
    match($0, /[0-9]{4}-[0-9]{2}-[0-9]{2}/);
    date = substr($0, RSTART, RLENGTH); 

    match($0, /[0-9]{2}:[0-9]{2}:[0-9]{2}/);
    time= substr($0, RSTART, RLENGTH);
    if (date && time) print "Data: " date " Time: " time
}')
    
     
    if [[ -n $timestamp ]]; then
        if [[ -z ${formatted_timestamp[$timestamp]} ]]; then
        formatted_timestamp[$timestamp]=$timestamp
        fi
    fi
fi
#-------combine timestamp


done < $log_file

#--------print failed login count-----------

summary=$(cat <<EOF
---------SUMMARY------------
Failed login attempts: $failed_login_count
Unique IP addresses: 
$(for ip in "${!unique_ip_address[@]}"; do echo "  - $ip"; done)
Timestamps:
$(for ts in "${formatted_timestamp[@]}"; do echo "  $ts"; done)
EOF
)

echo "$summary"