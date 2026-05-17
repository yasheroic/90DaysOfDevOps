# Shell Scripting Cheat Sheet

| Topic | Key Syntax | Example |
|-------|-----------|---------|
| Variable | `VAR="value"` | `NAME="DevOps"` |
| Argument | `$1`, `$2`, `$#` | `./script.sh arg1 arg2` |
| If | `if [ condition ]; then` | `if [ -f file ]; then` |
| For loop | `for i in list; do` | `for i in 1 2 3; do echo $i; done` |
| While | `while [ condition ]; do` | `while [ $i -lt 10 ]; do` |
| Function | `name() { ... }` | `greet() { echo "Hi"; }` |
| Grep | `grep pattern file` | `grep -i "error" log.txt` |
| Awk | `awk '{print $1}' file` | `awk -F: '{print $1}' /etc/passwd` |
| Sed | `sed 's/old/new/g' file` | `sed -i 's/foo/bar/g' config.txt` |

## Basics

**Shebang**: `#!/bin/bash` — tells OS to use bash interpreter

**Running**: `chmod +x script.sh && ./script.sh` or `bash script.sh`

**Comments**: `# comment` or `command # inline comment`

**Variables**: `VAR="value"` or `VAR=$1` (expand: `$VAR` or `"$VAR"`)

**Input**: `read name` or `read -p "Prompt: " name`

## Operators & Conditionals

**String**: `[ "$a" = "$b" ]`, `[ -z "$a" ]` (empty), `[ -n "$a" ]` (not empty)

**Integer**: `[ $a -eq $b ]`, `[ $a -lt $b ]`, `[ $a -gt $b ]`

**File**: `[ -f file ]` (exists), `[ -d dir ]` (is dir), `[ -r file ]` (readable)

**Logical**: `[ $a -eq 1 ] && echo "yes"` or `[ $a -eq 0 ] || echo "no"`

**Case**: `case $var in pattern) commands ;; esac`

## Loops

```bash
for i in 1 2 3; do echo $i; done
for i in {1..10}; do echo $i; done
for file in *.log; do cat "$file"; done
while read line; do echo "$line"; done < file.txt
until [ $count -eq 10 ]; do ((count++)); done
```

## Functions

```bash
my_function() {
    local var="$1"
    echo "Value: $var"
    return 0
}
my_function "argument"
```

## Text Processing

| Command | Use Case |
|---------|----------|
| `grep "ERROR" file` | Search lines |
| `grep -c "ERROR" file` | Count matches |
| `grep -n "ERROR" file` | Print line numbers |
| `awk -F: '{print $1}' file` | Extract column (: delimiter) |
| `sed 's/old/new/g' file` | Replace all |
| `cut -d: -f1 file` | Extract by delimiter |
| `sort \| uniq -c` | Count unique |
| `wc -l file` | Count lines |

## One-Liners

```bash
find . -name "*.log" -mtime +7 -delete  # Delete old logs
grep "ERROR" *.log \| wc -l            # Count errors
sed -i 's/old/new/g' *.conf            # Replace in all files
ps aux \| grep "service"               # Check if running
du -sh /* \| sort -hr \| head -5       # Top 5 large dirs
```

## Error Handling

```bash
set -e          # Exit on error
set -u          # Error on undefined variables
set -o pipefail # Catch pipe errors
set -x          # Debug mode (trace)
trap 'cleanup' EXIT    # Run cleanup on exit
echo "Exit code: $?"    # Check last command
```
