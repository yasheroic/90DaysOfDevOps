#!/bin/bash

SOURCE="${1:?Usage: $0 <source> <backup_dest>}"
DEST="${2:?Usage: $0 <source> <backup_dest>}"

if [ ! -d "$SOURCE" ]; then
    echo "Error: Source directory $SOURCE does not exist"
    exit 1
fi

mkdir -p "$DEST"

FILENAME="backup-$(date +%Y-%m-%d).tar.gz"
BACKUP_PATH="$DEST/$FILENAME"

tar -czf "$BACKUP_PATH" "$SOURCE" 2>/dev/null

if [ -f "$BACKUP_PATH" ]; then
    SIZE=$(du -h "$BACKUP_PATH" | cut -f1)
    echo "Backup created: $FILENAME (Size: $SIZE)"
else
    echo "Error: Backup failed"
    exit 1
fi

find "$DEST" -name "backup-*.tar.gz" -mtime +14 -delete 2>/dev/null
