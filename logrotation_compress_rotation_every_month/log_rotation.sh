#!/bin/bash

# Define log directory
log_location="/var/log/exacaster/highway"

# Get last month in YYYY-MM format
last_month=$(date --date="last month" +%Y-%m)

# Define archive folder
archive_folder="${log_location}/archive_${last_month}"
mkdir -p "$archive_folder"

declare compressed_file_count=0
declare not_movable

compress_log="/var/log/exacaster/highway/compress_log.log"

# Find and move files matching last month's pattern
for file in "$log_location"/customs.log.*; do
    # Extract the month from the filename using awk
    file_month=$(echo "$file" | awk -F'[.-]' '{print $3"-"$4}')

    if [[ $file == *.tar.gz ]]; then
        not_movable+=$(echo -e "$file is not movable, is already archive with extension .tar.gz")
    else
        if [[ "$file_month" == "$last_month" ]]; then
            mv "$file" "$archive_folder"
            (( compressed_file_count+=1 ))

        fi
    fi
done

# Compress the archive folder if it contains files
compressed_file="${log_location}/customs.log.${last_month}.tar.gz"
if [ "$(ls -A "$archive_folder")" ]; then
# Check if compressed file alredy exists
    if [ -f $compressed_file ]; then
        compressed_file="${log_location}/customs.log.${last_month}+$(date +%H%M%S).tar.gz"
    fi
    tar -czf "$compressed_file" -C "$log_location" "archive_${last_month}"
    # rm -rf "$archive_folder"
    status=$(echo "✅ Logs from $last_month have been archived and compressed: $compressed_file")
else
    status=$(echo "⚠️ No files found for last month ($last_month). Skipping compression.")
    # rmdir "$archive_folder"  # Remove empty folder
fi

summary=$(cat << EOF
-----COMPRESSION FILE SUMMARY-----
DATE:
$(date +%y-%m-%d_+%H:%M:%S)
Compressed file count:
$compressed_file_count
Compressed archive file:
$compressed_file
STATUS:
$status
NOT MOVABLE FILES:
$not_movable
EOF
)

if [ ! -f $compress_log ]; then
    touch $compress_log
fi
echo " $summary " >> $compress_log