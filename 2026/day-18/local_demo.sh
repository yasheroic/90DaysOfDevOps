#!/bin/bash

loc() {
local my_var=10

echo "value of local var inside local func is $my_var"
}

normal() {

nor_var=5
echo "value of normal func var $nor_var"
}

loc
normal

echo "value of myvar outside local is $my_var"
echo "value of normal var is $nor_var"