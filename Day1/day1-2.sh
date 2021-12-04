#!/bin/zsh

#Expecting local txt file path as input
input="$(cat $1)"

count=0

while [[ $(echo $input | wc -l) -gt 3 ]]; do
    firstNumber=$(echo $input | head -n 3 | awk '{s+=$1} END {print s}')
    input="$(echo $input | tail -n +2)"
    secondNumber=$(echo $input | head -n 3 | awk '{s+=$1} END {print s}')

    if [[ $secondNumber -gt $firstNumber ]]; then
        ((count++))
    fi

done

echo $count