#!/bin/bash
#
read -p "enter a num, (will go on till 0)" i

while [ "$i" -ge 0  ];do
        echo "$i"
        ((i--))
done

echo "Completed"