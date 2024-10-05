#!/bin/bash

location=./var/log/webserver
declare -A compress_file
backup_archive=logs-backup$(date +%Y-%m-%d).tar.gz

while read -r item; do
    if [ ${item##*.} == log ]; then
        if [[ -z ${compress_file[$item]} ]]; then
            compress_file[$item]=$item
        fi
    fi

   grep -i error "$item" >> error.log


done < <(find "$location" -type f -mtime +7)

    tar -czf "$backup_archive" "${compress_file[@]}"


#-------------compress summary----------------

compress_summary=$(cat << EOF
-------------COMPRESS SUMMARY-------------------
Files:
$(for file in "${compress_file[@]}"; do echo "$file"; done)
Into:
$backup_archive
EOF
)

echo "$compress_summary"