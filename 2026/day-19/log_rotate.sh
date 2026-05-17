#!/bin/bash

LOG_DIR="${1:-.}"

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory $LOG_DIR does not exist"
    exit 1
fi

compressed=$(find "$LOG_DIR" -name "*.log" -mtime +7 -exec gzip {} \; 2>/dev/null | wc -l)
deleted=$(find "$LOG_DIR" -name "*.gz" -mtime +30 -delete 2>/dev/null)

echo "Compressed: $compressed files"
echo "Deleted old .gz files"
