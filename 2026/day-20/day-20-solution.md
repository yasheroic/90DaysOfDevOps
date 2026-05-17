# Day 20 Solution: Log Analyzer and Report Generator

## Script: log_analyzer.sh

Minimal Bash script that analyzes log files and generates reports.

**Features:**
- Validates log file exists
- Counts total errors (ERROR or Failed keywords)
- Extracts critical events with line numbers
- Identifies top 5 error messages by frequency
- Generates timestamped report file
- Archives processed logs

**Usage:**
```bash
./log_analyzer.sh /path/to/logfile.log
```

## Tools Used

| Command | Purpose |
|---------|---------|
| `grep -c` | Count matching lines |
| `grep -n` | Print with line numbers |
| `sed` | Extract message text after ERROR keyword |
| `sort \| uniq -c \| sort -rn` | Count and rank occurrences |
| `head -5` | Get top 5 results |

## Sample Output

```
=== Log Analysis Report ===
Date: Fri May 18 01:49:00 UTC 2026
Log File: sample.log

Total Lines: 1523
Total Errors: 47

--- Critical Events ---
Line 84: 2025-07-29 10:15:23 CRITICAL Disk space below threshold
Line 217: 2025-07-29 14:32:01 CRITICAL Database connection lost

--- Top 5 Error Messages ---
 12 Connection timed out
  8 File not found
  5 Permission denied
  3 Disk I/O error
  2 Out of memory
```

## Key Learnings

1. **Text Processing**: `grep`, `sed`, `awk`, `sort`, `uniq` form powerful log analysis pipelines
2. **Validation**: Always check file existence and provide clear error messages
3. **Report Generation**: Redirecting output to files with timestamps enables audit trails
