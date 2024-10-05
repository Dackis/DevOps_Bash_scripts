#!/bin/bash

log_dir=./logs/myapp/
backup_dir=./backup/myapp_logs

if [ ! -d $backup_dir ] ; then
    mkdir -p $backup_dir
fi

# Find files older than 7 days and move them
find "$log_dir" -type f -mtime +7 | while read -r file; do
    # Extract the base filename (no path)
    base_file=$(basename "$file")
    
    # If a file with the same name exists in the backup directory, append a timestamp
    if [ -f "$backup_dir/$base_file" ]; then
        new_file="${backup_dir}/${base_file}_$(date +"%H%M%S")"
    else
        new_file="${backup_dir}/${base_file}"
    fi
    
    # Move the file to the backup directory with the new name
    mv "$file" "$new_file"
    
    # Output the name of the moved file
    echo "Moved: $file to $new_file"
done

archive_name="backup_$(date +"%Y%m%d_%H%M%S").tar.gz"
tar -czf "${backup_dir}/backup_$(date +"%Y%m%d_%H%M%S").tar.gz" -C "$backup_dir" .
echo "Compressed files into: ${backup_dir}/backup_$(date +"%Y%m%d_%H%M%S").tar.gz"


