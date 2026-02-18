#!/bin/bash
#
read -p "Please enter a number: " num

if [ $num -gt 0 ]; then
        echo "Number is positive"
elif [ $num -lt 0 ]; then
        echo "Number is Negative"
else
        echo "It is Zero"
fi