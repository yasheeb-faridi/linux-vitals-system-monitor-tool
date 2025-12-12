#!/bin/bash

# Define thresholds (in percentage)
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Calculating the Warning Threshold (80%) using bc
# Define refresh interval in seconds
SLEEP_INTERVAL=5

# Define Color Variables using tput
COLOR_GREEN=$(tput setaf 2)   # Success/OK
COLOR_YELLOW=$(tput setaf 3)  # Warning
COLOR_RED=$(tput setaf 1)     # Alert
COLOR_BLUE=$(tput setaf 4)    # Labels/Headers
COLOR_RESET=$(tput sgr0)      # Reset color

# Function to send an alert (uses tput red text)
send_alert() {
    # $1 = Resource type (e.g., CPU)
    # $2 = Current usage value (e.g., 90)
    echo "${COLOR_RED}ALERT: $1 usage exceeded threshold! Current value: $2%${COLOR_RESET}"
}

# Function to display the usage percentage with appropriate color
display_usage() {
    # $1 = Resource name (e.g., CPU)
    # $2 = Current usage value (integer)
    # $3 = Threshold value (integer)
    
    local value=$2
    local threshold=$3
    
    if ((value >= threshold)); then
        color=$COLOR_RED
    else
        color=$COLOR_GREEN
    fi
    
    echo "${COLOR_BLUE}$1 usage:${COLOR_RESET} ${color}$value%${COLOR_RESET}"
}

# Main monitoring loop
while true; do
    clear
    echo "${COLOR_BLUE}=== Linux Vital System Monitor ($(date)) ===${COLOR_RESET}"
    echo "Thresholds: CPU=${CPU_THRESHOLD}%, Memory=${MEMORY_THRESHOLD}%, Disk=${DISK_THRESHOLD}%"
    echo "-----------------------------------"
    
    # 1. Monitor CPU Usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    cpu_usage_int=${cpu_usage%.*}
    
    display_usage "CPU" "$cpu_usage_int" "$CPU_THRESHOLD" 
    
    if ((cpu_usage_int >= CPU_THRESHOLD)); then
        send_alert "CPU" "$cpu_usage_int"
    fi

    echo "-----------------------------------"
    
    # 2. Monitor Memory Usage
    memory_usage=$(free | awk '/Mem/ {printf("%3.1f", ($3/$2) * 100)}')
    memory_usage_int=${memory_usage%.*}
    
    display_usage "Memory" "$memory_usage_int" "$MEMORY_THRESHOLD"
    
    if ((memory_usage_int >= MEMORY_THRESHOLD)); then
        send_alert "Memory" "$memory_usage_int"
    fi
    
    echo "-----------------------------------"
    
    # 3. Monitor Disk Usage (Checks root partition "/")
    disk_usage_raw=$(df -h / | awk '/\// {print $(NF-1)}')
    disk_usage_int=${disk_usage_raw%?}
    
    display_usage "Disk" "$disk_usage_int" "$DISK_THRESHOLD"
    
    if ((disk_usage_int >= DISK_THRESHOLD)); then
        send_alert "Disk" "$disk_usage_int"
    fi

    echo "-----------------------------------"
    
    # Wait for the next check
    sleep $SLEEP_INTERVAL
done