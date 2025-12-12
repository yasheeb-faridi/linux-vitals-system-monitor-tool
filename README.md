# **1️⃣ 📄 Automated Log Reporting Script (log_report.sh)**
 
This is a simple but useful Linux system automated log reporting tool. This script gathers system activity, authentication failures and warning counts into a single easy-to-read formatted report.

This project showcases practical Linux System Admin skills including log analysis, shell scripting, automation, and cron-based scheduling.  

**🚀 Project Overview**

log_report.sh is a Bash script that gathers different types of system logs:  
1. System logs from "journalctl". journalctl gathers system and kernel logs from the systemd journal.
2. Authentication logs (failed login attempts) via (/var/log/auth.log)
3. Warning messages (counted via `journalctl`)  
4. It then formats them with headers and timestamps and saves everything into a consolidated file: log_report.txt  
5. we can use cron job to schedules this script to run every 6 hours, automatically generating updated reports.  

This tool is useful for: 
1. Linux System administrators  
2. Cloud engineers  
3. DevOps engineers  
4. Anyone who wants quick access to system activity

⚙️ How to Setup and Automate
1. Create the script: Save the code above as log_report.sh.
2. Make it executable: Give the file execution permissions.
    <!-- Bash -->
    `$ chmod +x log_report.sh`

3. Automate with Cron: Open your crontab editor to schedule the script to run every 6 hours.
    `$ crontab -e`

    Add the following line at the end of the file:

    `$ 0 */6 * * * /path/to/log_report.sh`
4. You can also change path of the script (just replace `/path/to/` with your actual path):

🛠️ Features 

1️⃣ 
✔ Automatically collects:  
  Latest 20 system log entries  
  Latest 10 failed authentication attempts  
  Total warning count
  
✔ Formats each section with:  
  Clear headers  
  Timestamps  
  Organized output  

✔ Stores results in:  
  `$HOME/log_reports/log_report.txt`

✔ Runs automatically every 6 hours using cron  

2️⃣ Each section is wrapped in a timestamped header:

3️⃣ The final output includes:  
  System activity  
  Failed logins  
  Warning count
  All in one place for easy access.  

📦 Project Structure  
log_report/  
│  
├── log_report.sh        # Main script  
└── log_report.txt      # Generated report 


# **2️⃣ Linux System Monitor**
This is a simple Bash script that monitors CPU, memory, and disk usage, and displays an alert if any of them exceed a defined threshold.

This script demonstrates using fundamental Linux commands (top, free, df) combined with awk and basic Bash logic (loops and conditional statements) to create a real-time, terminal-based monitoring solution.

```bash
1. Make it executable:
   $ chmod +x system_monitor.sh

2. Run it on the terminal: 
   $ ./system_monitor.sh
```
**Important** Stop execution: Press Ctrl+C to stop the continuous loop

# *3️⃣ Colored system monitor tool*
This script provides a much more intuitive, color-coded view of the system's health.

This is the same monitoring tool but with a colour output so that it is easy to read.

I defined variables like COLOR_GREEN, COLOR_RED, and COLOR_RESET using tput. This makes the code much cleaner than repeating the tput commands.
