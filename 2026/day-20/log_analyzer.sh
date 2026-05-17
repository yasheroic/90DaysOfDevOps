#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Error: No log file provided"
    echo "Usage: $0 <logfile>"
    exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file '$LOG_FILE' does not exist"
    exit 1
fi

REPORT_DATE=$(date +%Y-%m-%d)
REPORT_FILE="log_report_${REPORT_DATE}.txt"

{
    echo "=== Log Analysis Report ==="
    echo "Date: $(date)"
    echo "Log File: $LOG_FILE"
    echo ""
    
    echo "Total Lines: $(wc -l < "$LOG_FILE")"
    ERROR_COUNT=$(grep -c "ERROR\|Failed" "$LOG_FILE")
    echo "Total Errors: $ERROR_COUNT"
    echo ""
    
    echo "--- Critical Events ---"
    grep -n "CRITICAL" "$LOG_FILE" | head -10 || echo "No critical events found"
    echo ""
    
    echo "--- Top 5 Error Messages ---"
    grep "ERROR" "$LOG_FILE" | sed 's/.*ERROR[: ]*//' | sort | uniq -c | sort -rn | head -5 || echo "No errors found"
    
} > "$REPORT_FILE"

echo "Report generated: $REPORT_FILE"

# Optional: Archive
mkdir -p archive
cp "$LOG_FILE" archive/ 2>/dev/null && echo "Log archived"
