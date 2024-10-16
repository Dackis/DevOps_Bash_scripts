services=$@
log_file=service.log
date=$(date +"%Y-%m-%d %H:%M:%S")
$admin_email="your@email" #insert your email here to get notifications if you have mail utility in your system

for service_names in $services; do

systemctl is-active $service_names --quiet
    if [ $? -eq 0 ]; then
        echo "$date Service $service_names is active" >> $log_file 
    else
        echo "ALERT $date  Service: $service_names is inactive. Restarting..." >> $log_file
        sudo systemctl restart $service_names >> /dev/null
            if systemctl is-active $service_names --quiet; then
                echo "Service $service_names restarted and now ACTIVE" >> $log_file
            else
                echo "ERROR: $date $service_names Service restarted but still inactive" >> $log_file 
                echo "ERROR: $date $service_names Service restarted but still inactive" | mail -s "$service_names failed to restart on WSL" $admin_email  
                    if [ $? -eq 0 ] ; then
                        echo "$date Email succesfully sent to ADMIN" >> $log_file
                    else 
                        echo "$date email failed to send to admin " >> $log_file
                    fi
            fi
    fi
done


