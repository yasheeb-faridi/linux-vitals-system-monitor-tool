#!/bin/bash

# 1. Define the report path and file
REPORT_DIR="$HOME/log_reports"
REPORT_FILE="$REPORT_DIR/log_report.txt"

# Ensure the report directory exists
mkdir -p "$REPORT_DIR"

# 2. A Timestamped Header inside the report file
echo "=============================================" >> "$REPORT_FILE"
echo "System Log Report: $(date)" >> "$REPORT_FILE"
echo "=============================================" >> "$REPORT_FILE"

# 3. Gather System Logs
# Uses journalctl to fetch the latest 20 entries of general system activity
echo -e "\n### [1] System Logs (Recent Activity)" >> "$REPORT_FILE"
journalctl -n 20 --no-pager >> "$REPORT_FILE"

# 4. Gather Authentication Failures
# Searches /var/log/auth.log for failed password attempts
echo -e "\n### [2] Authentication Failures" >> "$REPORT_FILE"
if [ -f /var/log/auth.log ]; then
    grep "Failed password" /var/log/auth.log | tail -n 10 >> "$REPORT_FILE" || echo "No recent failed logins." >> "$REPORT_FILE"
else
    echo "Auth log not found. Checking journalctl..." >> "$REPORT_FILE"
    journalctl _SYSTEMD_UNIT=ssh.service | grep "Failed" | tail -n 10 >> "$REPORT_FILE"
fi

# 5. Calculate Warning Counts
# Uses grep and wc to count occurrences of "warning" in the last 6 hours
# wc -l	Counts the lines of filtered output to provide a total warning tally.
echo -e "\n### [3] Warning Counts (Last 6 Hours)" >> "$REPORT_FILE"
WARN_COUNT=$(journalctl --since "6 hours ago" | grep -i "warning" | wc -l)
echo "Total system warnings detected: $WARN_COUNT" >> "$REPORT_FILE"


echo -e "\n--- End of Snapshot. ---\n" >> "$REPORT_FILE"