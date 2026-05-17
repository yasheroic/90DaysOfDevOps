#!/bin/bash

LOG_FILE="/var/log/maintenance.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log_message "Maintenance started"

# Log rotation
bash /path/to/log_rotate.sh /var/log/myapp >> "$LOG_FILE" 2>&1
log_message "Log rotation completed"

# Backup
bash /path/to/backup.sh /var/www /backup/destination >> "$LOG_FILE" 2>&1
log_message "Backup completed"

log_message "Maintenance finished"
