#!/bin/bash

read -p "Please enter filename: " file

if [ -f $file ] >/dev/null ; then
        echo "File $file already exists"
else
        echo "File doesnt Exist"
fi