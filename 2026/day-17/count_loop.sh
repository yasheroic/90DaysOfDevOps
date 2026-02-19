#!/bin/bash

<<com
for i in {1..10}; do
        echo "$i"
done
com

for (( i=1; i<=10; i++ ));do
        echo "$i"
done
