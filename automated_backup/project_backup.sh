#!/bin/bash

backup_date="backup"$(date +"%Y-%m-%d+%H%M%S")
backup_name=$backup_date.tar.gz
archive_log_date="backup"$(date +"%Y%m%d")
archive_log_name=$archive_log_date.log

tar czf $backup_name ./project
echo "$backup_name Created"
mv ./$backup_name ./backup


echo "$(date +"%Y-%m-%d+%H:%M:%S") - "$backup_name" created" >> ./logs/backup.logs

if [[ $(stat -c %s ./logs/backup.logs) -gt 1024 ]]; then
    echo "./logs/backup.logs file reached 1MB, archiving file and creating new" 
    mv ./logs/backup.logs ./logs/$archive_log_name
    touch ./logs/backup.logs
fi