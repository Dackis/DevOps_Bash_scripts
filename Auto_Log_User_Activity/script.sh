#!/bin/bash

log_file=./var/log/auth.log
success_count=0
failed_count=0
declare -A success_user_count  # Tracks successful logins per user
declare -A failed_user_count   # Tracks failed logins per user
declare -A ip_count=0

current_date_unix=$(date +%s)
time_24_hours_ago=$((current_time_unix - 86400))

while IFS= read -r line; do

    logdate=$( echo "$line" | awk '{print $1, $2, $3}')
    current_date=$(date +%Y)
    full_date="$logdate $current_year"
    log_time_unix=$(date -d "$full_date" +%s)

    timestamp=$(echo "$line" | awk '{
    month = $1;
    day = $2;
    time = $3;
    if (time && day && month) {
        print "Date: " month " " day " Time: " time
    }
}')



status=$(echo $line | awk '{print $6}')


if [[ $log_time_unix -ge $time_24_hours_ago ]]; then
    if [[ $status == Accepted ]]; then
    # Successful login: extract username and IP
        username=$(echo "$line" | awk '{print $9}')
        IP_address=$(echo "$line" | awk '{print $11}')    
        # Increment success count
            ((success_count++))

        # Track successful logins by user
        if [[ -z ${success_user_count[$username]} ]]; then
            success_user_count[$username]=1
        else
            ((success_user_count[$username]++))
        fi 

elif [[ $status == "Failed" ]]; then
            # Failed login: extract username and IP
            if echo "$line" | grep -q "invalid user"; then
                # Extract "invalid user" case
                username=$(echo "$line" | awk '{print $11}')
            else
                # Extract normal failed login case
                username=$(echo "$line" | awk '{print $9}')
            fi

            IP_address=$(echo "$line" | awk '{print $13}')
            
            # Increment failed count
            ((failed_count++))
            
            # Track failed logins by user
            if [[ -z ${failed_user_count[$username]} ]]; then
                failed_user_count[$username]=1
            else
                ((failed_user_count[$username]++))
            fi
            
            # Track failed login attempts per IP for alerting
            if [[ -z ${ip_count[$IP_address]} ]]; then
                ip_count[$IP_address]=1
            else
                ((ip_count[$IP_address]++))
        fi
    fi
fi
    

done <$log_file

# Output the results
echo "Total successful logins: $success_count"
echo "Total failed logins: $failed_count"

echo "Successful logins by user:"
for user in "${!success_user_count[@]}"; do
    echo "$user: ${success_user_count[$user]} successful attempts"
done

echo "Failed logins by user:"
for user in "${!failed_user_count[@]}"; do
    echo "$user: ${failed_user_count[$user]} failed attempts"
done

# Alert if any IP has more than 5 failed attempts
echo "Alerting on IPs with more than 5 failed login attempts:"
for ip in "${!ip_count[@]}"; do
    if [[ ${ip_count[$ip]} -gt 5 ]]; then
        echo "Alert: IP $ip has ${ip_count[$ip]} failed login attempts"
    fi
done