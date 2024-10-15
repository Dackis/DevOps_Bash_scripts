#!/bin/bash

LOG_FILE="sample_log.log"

# Create a sample log file with random data
echo "2024-10-01 12:00:01 ERROR Failed to connect to database" >> $LOG_FILE
echo "2024-10-01 12:05:43 INFO User login successful: user_id=123" >> $LOG_FILE
echo "2024-10-01 12:10:23 WARNING Disk space running low on /dev/sda1" >> $LOG_FILE
echo "2024-10-01 12:15:12 INFO Scheduled backup completed successfully" >> $LOG_FILE
echo "2024-10-01 12:20:50 ERROR Unable to resolve host: example.com" >> $LOG_FILE
echo "2024-10-02 09:00:34 INFO User logout successful: user_id=123" >> $LOG_FILE
echo "2024-10-02 09:10:02 WARNING High memory usage detected" >> $LOG_FILE
echo "2024-10-02 09:30:45 ERROR Service unavailable: service_id=xyz" >> $LOG_FILE
echo "2024-10-02 09:45:18 INFO Database replication completed" >> $LOG_FILE
echo "2024-10-02 10:15:25 INFO User login successful: user_id=456" >> $LOG_FILE
echo "2024-10-03 08:25:30 WARNING CPU usage at 95%" >> $LOG_FILE
echo "2024-10-03 08:30:40 ERROR Failed to write to disk: /dev/sdb" >> $LOG_FILE
echo "2024-10-03 08:45:55 INFO System rebooted successfully" >> $LOG_FILE
echo "2024-10-03 09:10:12 WARNING Network latency high for host: example.com" >> $LOG_FILE
