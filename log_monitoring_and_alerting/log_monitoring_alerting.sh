#!/bin/bash

# Function to convert month names to numbers

log_file=./access.log
current_time=$(date +%s)
time_24_hours_ago=$((current_time - 86400))
count_500=0
count_404=0
backup_archive=logs-backup$(date +%Y-%m-%d).tar.gz

while IFS= read -r line; do 

log_date=$(echo "$line" | awk '{gsub(/\[|\]/, "", $4); print $4}')
log_date=$(echo $log_date | sed 's/:/ /1')

# Now convert this to a UNIX timestamp
log_time_unix=$(date -d "$log_date" +%s)

# echo "Time 24hours ago $time_24_hours_ago"
# echo "Log date in UNIX timestamp: $log_time_unix"


if [ "$log_time_unix" -le "$time_24_hours_ago" ]; then
status_code=$(echo $line | awk '{print $9}')
    case $status_code in
    500) 
    ((count_500++))
   
    ;;
    
    404) 
    ((count_404++))
    ;;
    esac

fi
    
done <$log_file

if [ $count_500 -ge 100 ]; then
echo "Error - 500 more than 100: Alert in $log_file Total count: $count_500"
fi

if [ $count_404 -ge 50 ]; then
echo "Error - 404 more than 50: Alert in $log_file Total count: $count_404"
fi

log_size=$(stat -c%s $log_file)
log_size_kb=$((log_size/ 1024 ))
echo "Log size: $log_size bytes converted to $log_size_kb KB"

#floating number to printf
#printf "%.2f KB\n" "$(echo "$log_size / 1024" | bc -l)"

if [ ! -d ./backup ]; then
    echo "Creating backup dir"
    mkdir backup
fi
#-----------log rotation-----------------------


    tar -czf $backup_archive $log_file
    mv $backup_archive ./backup
    rm $log_file
    echo "$log_file reached 50KB, $log_file archiving into $backup_archive - moving to ./backup and deleting $log_file"
    