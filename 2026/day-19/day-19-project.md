# Day 19 Project: Shell Scripting - Log Rotation, Backup & Crontab

## Scripts Created

### 1. log_rotate.sh
Rotates logs by compressing files older than 7 days and deleting .gz files older than 30 days.
Usage: `./log_rotate.sh /var/log/myapp`

### 2. backup.sh
Creates timestamped backups and removes backups older than 14 days.
Usage: `./backup.sh /source/path /backup/destination`

### 3. maintenance.sh
Combines log rotation and backup with timestamped logging.

## Cron Entries

```
# Run log rotation daily at 2 AM
0 2 * * * /path/to/log_rotate.sh /var/log/myapp

# Run backup every Sunday at 3 AM
0 3 * * 0 /path/to/backup.sh /var/www /backup

# Run health check every 5 minutes
*/5 * * * * /path/to/healthcheck.sh

# Run maintenance daily at 1 AM
0 1 * * * /path/to/maintenance.sh
```

## Key Learnings

1. **Cron Scheduling**: 5-field format (minute, hour, day, month, weekday) controls script execution frequency
2. **Log Management**: Using `find` with `-mtime` efficiently locates and processes old files
3. **Backup Automation**: Timestamped archives with cleanup prevent disk space issues in production
