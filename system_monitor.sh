#!/bin/bash

# Define thresholds (in percentage)
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Refresh interval in seconds
SLEEP_INTERVAL=5

# Function to send an alert (uses tput for red text)
send_alert() {
    # $1 = Resource type (e.g., CPU)
    # $2 = Current usage value (e.g., 90)
    echo "$(tput setaf 1)ALERT: $1 usage exceeded threshold! Current value: $2%$(tput sgr0)"
}

# Main monitoring loop
while true; do
    clear
    echo "=== Linux System Monitor ($(date)) ==="
    echo "Thresholds: CPU=${CPU_THRESHOLD}%, Memory=${MEMORY_THRESHOLD}%, Disk=${DISK_THRESHOLD}%"
    echo "-----------------------------------"
    
    # 1. Monitor CPU Usage (Calculates user + system time from top)
    # Using top for one batch run (-bn1), grep for Cpu(s) line, awk to sum user ($2) and system ($4)
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    # Strip the decimal part for integer comparison
    cpu_usage_int=${cpu_usage%.*}
    
    echo "Current CPU usage: $cpu_usage_int%"
    if ((cpu_usage_int >= CPU_THRESHOLD)); then
        send_alert "CPU" "$cpu_usage_int"
    fi

    echo "-----------------------------------"
    
    # 2. Monitor Memory Usage (Calculates used / total * 100 from free)
    # Using free to get memory stats, awk to calculate used percentage: ($3/$2)*100
    # $2 is total memory, $3 is used memory on the Mem line (NR==2)
    memory_usage=$(free | awk '/Mem/ {printf("%3.1f", ($3/$2) * 100)}')
    memory_usage_int=${memory_usage%.*}
    
    echo "Current Memory usage: $memory_usage_int%"
    if ((memory_usage_int >= MEMORY_THRESHOLD)); then
        send_alert "Memory" "$memory_usage_int"
    fi
    
    echo "-----------------------------------"
    
    # 3. Monitor Disk Usage (Checks root partition "/")
    # Using df -h to get human-readable disk stats, awk to extract the Use% (field NF-1) for the root '/' filesystem
    disk_usage_raw=$(df -h / | awk '/\// {print $(NF-1)}')
    # Remove the '%' symbol
    disk_usage_int=${disk_usage_raw%?}
    
    echo "Current Disk usage for /: $disk_usage_int%"
    if ((disk_usage_int >= DISK_THRESHOLD)); then
        send_alert "Disk" "$disk_usage_int"
    fi

    echo "-----------------------------------"
    
    # Wait for the next check
    sleep $SLEEP_INTERVAL
done