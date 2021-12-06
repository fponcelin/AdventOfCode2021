#!/bin/zsh

#Expecting local txt file path as input
input="$(cat $1)"
fishArr=(${(@s:,:)input})
day=1

while [[ $day -le 80 ]]; do
    currentFishCount=${#fishArr[@]}
    echo "Day $day of 80. Current fish count: $currentFishCount\r\c"
    
    for i in {1..$currentFishCount}; do
        if [[ $fishArr[$i] -gt 0 ]]; then
            ((fishArr[$i]--))
        else
            fishArr[$i]=6
            fishArr+=(8)
        fi
    done
    ((day++))
done

echo ""
echo "Lanternfish count after 80 days: ${#fishArr[@]}"