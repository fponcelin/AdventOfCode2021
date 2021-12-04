#!/bin/zsh

#Expecting local txt file path as input
input="$(cat $1)"

count=0

while [[ $(echo $input | wc -l) -gt 1 ]]; do
    firstNumber=$(echo $input | head -n 1)
    secondNumber=$(echo $input | head -n 2 | tail -n 1)

    if [[ $secondNumber -gt $firstNumber ]]; then
        ((count++))
    fi

    input="$(echo $input | tail -n +2)"
done

echo $count