#!/bin/bash

greet() {
read -p "Enter your name: " name
echo "Hello, $name"
}

add() {

read -p "Enter first number: " a

read -p "Enter Second number: " b

sum=$((a+b))

echo "sum is $sum"
}

greet
add