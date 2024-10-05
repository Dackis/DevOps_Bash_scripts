#!/bin/bash

files_to_backup=(./files/test.txt ./files/log.log)
# echo ${files_to_backup[@]}
backup_dir="./backup"
date_to_add=$(date +%Y-%m-%d+%H%m%S)
log_dir="./logs"
file_treshold=3

for files in ${files_to_backup[@]}; do
    #---extract extension-----
    extension="${files##*.}"
    #---get basename without extension----
    base_filename=$(basename "$files" ."$extension")
    #---get backup_files in backup_dir without date and extension, extract only basename----
    backup_files=($(ls "$backup_dir"/"${base_filename}"_*."$extension" 2>/dev/null))

    if [ ${#backup_files[@]} -eq 0 ]; then
        echo "No backup found for $files"
        cp "$files" "$backup_dir"/"$base_filename"_"$date_to_add"."$extension"
        echo "$date_to_add" - "$files" "backup created $backup_dir"/"$base_filename"_"$date_to_add"."$extension">>"$log_dir"/"$base_filename".log
    else
        most_recent_backup=$(ls -t "${backup_files[@]}" | head -n 1)

        if diff "$files" "$most_recent_backup" >/dev/null; then
            echo "$date_to_add" - "File '$files' is the same as its most recent backup '$most_recent_backup'.">>"$log_dir"/"$base_filename".log
        
        else
            echo "File '$files' differs from its most recent backup '$most_recent_backup'.">>"$log_dir"/"$base_filename".log
            cp "$files" "$backup_dir"/"$base_filename"_"$date_to_add"."$extension"
            echo "$date_to_add" - "$files" backed up to "$backup_dir"/"$base_filename"_"$date_to_add"."$extension" >>"$log_dir"/"$base_filename".log

        fi
    fi

    if [ ${#backup_files[@]} -gt $file_treshold ]; then
        echo "${#backup_files[@]} is more than 7, deleting"
        file_to_delete=$(find "$backup_dir"/"$base_filename"_*."$extension" -type f -printf '%T@+ %p\n' | sort -n | head -n 1| awk '{print $2}')
        echo " file to delete: $file_to_delete"
        echo "$base_filename backup count reached $file_treshold Oldest file in backup folder for "$base_filename" - "$file_to_delete, deleting file!!!>>"$log_dir"/"$base_filename".log
        rm $file_to_delete   
    else
        echo "backup files count: ${#backup_files[@]}">/dev/null
    fi

done

    # find ./backup/test_*.txt -type f -printf '%T+ %p\n' | sort | head -n 1

# ls -t ./backup | head -n 1


# date +%Y-%m-%d+%H%m%S