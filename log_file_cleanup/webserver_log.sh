#!/bin/bash

# -- variables --

location=./var/log/webserver # - location of log files
declare -A compress_file # - array of files to compress
backup_archive=logs-backup$(date +%Y-%m-%d_%H:%M:%S).tar.gz # - backup archive name
compress_log=./var/log/compress.log # - compress log file
date=$(date +%Y-%m-%d_%H:%M:%S) # - date and time
compress_error=./var/log/compress_error.log # - compress error log file
backup_info=""



while read -r item; do
    if [ ${item##*.} == log ]; then
        if [[ -z ${compress_file[$item]} ]]; then
            compress_file[$item]=$item
        fi
    fi

   grep -iE "(error|critical|alert)" "$item" >> error.log # captures errors in the log files


done < <(find "$location" -type f -mtime +6) # find files older than 6 days

#check if files are created or not
if [ ! -f "$compress_log" ]; then
    touch $compress_log
else
    echo "file exists"
fi

if [ ! -f "$compress_error" ]; then
    touch $compress_error
else
    echo "file exists"
fi

if [ ${#compress_file[@]} -eq 0 ]; then
    compress_answer=$(echo "No files to compress")
else
tar -czf "$backup_archive" "${compress_file[@]}" > "$compress_error" 2>&1

    if [ -f $backup_archive ]; then
        compress_answer=$(echo "Compress success")
        rm ${compress_file[@]}
    else
        compress_answer=$(echo "[ERROR] Compress Failed")
    fi
fi

    

error=$(cat "$compress_error")

if [[ $compress_answer == "Compress success" ]]; then
  backup_info="Into: $backup_archive"
fi

#-------------compress summary----------------

compress_summary=$(cat << EOF
-------------COMPRESS SUMMARY-------------------
Date:
$date
Compress Status:
$compress_answer
Files:
$(for file in "${compress_file[@]}"; do echo "$file"; done)
Into:
$backup_info
Error:
$error
EOF
)
rm "$compress_error"
echo "$compress_summary" >> $compress_log