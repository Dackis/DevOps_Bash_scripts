#!/bin/bash

date=$(date +"%Y%m%d_%H%M%S")
backup_location=./archyvas/
move_from=./to_move/
logs=./logs/rsync_log.log

transfer () {
    rsync -a --remove-source-files $move_from $backup_location
    if [ $? == 0 ]; then
    echo "Severity: INFO : $date Rsync from $move_from to $backup_location SUCCESFUL" >>$logs
    fi
}

archive_directory () {
    
    local backup_name=$(basename $directory)
    tar czf  "$backup_name"_"$date".tar.gz $directory
    mv "$backup_name"_"$date".tar.gz $move_from
    echo "Severity: INFO: $date - "$backup_name"_"$date".tar.gz created and moved to: $move_from" >> $logs
    }

archive_file_as_directory_list () {
    echo "Severity: INFO: $date - Creating backup from directory list:$file" >> $logs
    while IFS= read -r directory; do
    local backup_name=$(basename $directory)
    tar czf  "$backup_name"_"$date".tar.gz $directory
    mv "$backup_name"_"$date".tar.gz $move_from
    echo "Severity: INFO: $date - Creating backup from directory $directory" >> $logs
    echo "Severity: INFO: $date - "$backup_name"_"$date".tar.gz created and moved to: $move_from" >> $logs
    done
}


echo "Insert your option 1-directories as argument 2-directories from file"
read choice

case $choice in
    1)
    echo "Directory as argument"
    read directory
    archive_directory
    echo "Would you like to rsync to $backup_location - YES/NO"
    read input
    if [ $input == "YES" ]; then
    transfer
    else 
    exit
    fi
    ;;
    2)
    echo "Directory as file"
    read file
    while IFS= read -r directory || [ -n "$directory" ]; do
    echo "$directory"
    archive_file_as_directory_list
    done < $file
    echo "Would you like to rsync to $backup_location - YES/NO"
    read input
    if [ $input == "YES" ]; then
    transfer
    else 
    exit
    fi
    # backup_folder=$directory
    
    ;;
    *)
    exit
    ;;
esac