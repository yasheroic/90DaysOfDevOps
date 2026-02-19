#!/bin/bash

#read -p "Enter your name: " name

if [ "$#" -lt 1  ]; then
        echo "usage is ./hello.sh <your_name>"
        exit 1
fi

echo "hello $@"