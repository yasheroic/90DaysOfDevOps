#!/bin//bash

set -euo pipefail

host_os() {
echo "hostname"
hostname
cat /etc/os-release | grep VERSION

}

upt() {
echo "uptime"
uptime
}

disk_size(){

echo "disk_size"
df -h | sort -rk5 | head -n 5
}

mem(){

echo "memory"
free -h
}

cpu_con() {

echo "top 5 cpu"
ps --sort=-%cpu | head -n 5
}

main() {

host_os
upt
disk_size
mem
cpu_con
}

main