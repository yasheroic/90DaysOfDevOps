#!/bin/bash

check_disk() {
df -h $1
}

check_memory() {

free -h
}

main() {

check_disk /
echo "==============="
check_memory
}

main