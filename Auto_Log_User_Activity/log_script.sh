#!/bin/bash

log_file="./var/log/auth.log"  # Path to the log file
num_entries=500               # Number of log entries to generate
users=("alice" "bob" "charlie" "dave")  # List of users to simulate
ips=("192.168.1.1" "192.168.1.10" "10.0.0.5" "10.0.0.6")  # List of IPs
statuses=("Accepted" "Failed")  # Login status

# Remove old log file if it exists
[ -f "$log_file" ] && sudo rm "$log_file"

# Generate random log entries
for i in $(seq 1 $num_entries); do
    # Randomly pick user, IP, and login status
    user=${users[$RANDOM % ${#users[@]}]}
    ip=${ips[$RANDOM % ${#ips[@]}]}
    status=${statuses[$RANDOM % ${#statuses[@]}]}
    
    # Generate a random timestamp in the last 24 hours
    timestamp=$(date -d "$((RANDOM % 1440)) minutes ago" +"%b %d %H:%M:%S")
    
    if [ "$status" == "Accepted" ]; then
        # Simulate a successful login
        echo "$timestamp myhost sshd[12345]: $status password for $user from $ip port 22 ssh2" | sudo tee -a "$log_file"
    else
        # Simulate a failed login
        echo "$timestamp myhost sshd[12345]: $status password for invalid user $user from $ip port 22 ssh2" | sudo tee -a "$log_file"
    fi
done

echo "Random logs generated in $log_file"
