#!/bin/bash

read -p "enter service name: " service

read -p "Do you want to check the status of $service please answer in-(y/n): " choice

if [ "$choice" == "y" ];then
        sudo systemctl status "$service"
else
        echo "skipped..."
fi