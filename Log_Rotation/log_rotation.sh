#!/bin/bash

log_file=$1 # ./log/my_app.log
rotation_log="rotation.log"
backup_dir="./backup"
backup_date="$(date +%Y-%m-%d+%H%M%S)"
log_count_threshold=5
log_file_size=$(stat -c%s $log_file)
log_extension="${log_file##*.}"

log_basename=$(basename "$log_file" ."$log_extension")



if [ ! -f $log_file ]; then
    echo "Log file: "$log_file" is not a file"
    else    
    if [ $log_file_size -ge 1 ]; then
            #-----check if backup dir exists--------
        if [ ! -d $backup_dir ]; then
        echo "backup directory does not exist, creating $backup"
        mkdir $backup_dir
        fi
    backed_log="${log_basename%%.*}"
    mv $log_file $backup_dir/$backed_log$backup_date.$log_extension
    touch $log_file    
    #-----log rotation-----
    backup_files=($(ls "$backup_dir"/"${log_basename}"*."$log_extension"))
    if [ ${#backup_files[@]} -gt "$log_count_threshold" ]; then
        backup_to_delete=$(find "$backup_dir"/"$log_basename"*."$log_extension" -type f -printf '%T@+ %p\n' | sort -n | head -n 1| awk '{print $2}')
        # Log rotation process
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Rotated log file '$log_file' to '$backup_dir/$backed_log_$backup_date.$log_extension'" >> $rotation_log
        tar czf "$backup_to_delete.tar.gz" -C "$backup_dir" "$(basename "$backup_to_delete")"
        mv "$backup_to_delete.tar.gz" ./archive/
        # Check if the compression was successful
        if [ $? -eq 0 ]; then
            echo "$(date +"%Y-%m-%d %H:%M:%S") - Successfully compressed '$backup_dir/$backed_log_$backup_date.$log_extension' to '$backup_dir/$backed_log_$backup_date.$log_extension.tar.gz'" >> $rotation_log
        else
            echo "$(date +"%Y-%m-%d %H:%M:%S") - ERROR: Failed to compress '$backup_dir/$backed_log_$backup_date.$log_extension'" >> $rotation_log
        fi
        rm $backup_to_delete
        echo "$backup_date Email sent because new information was added in rotation log" | mail -s "INFORMATION!!! $backup_date Rotation.log" evaldas.samavicius@gmail.com 
        
    fi
    else
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Log file size is $log_file_size, skipping rotation." >> $rotation_log
    fi
fi

