#!/bin/zsh

#Expecting local txt file path as input
input="$(cat $1)"
drawStr="$(echo $input | head -n 1)"
drawArr=(${(@s:,:)drawStr})
grids="$(echo $input | tail -n +3)"
h="a a a a a"
v="a
a
a
a
a"
winGrid=""
lastNum=""

#Convert the grids string to an array of grid strings
i=1
declare -a gridsArr
while [ "$grids" != "" ]; do
    gridsArr[$i]="$(echo $grids | head -n 5)"
    grids="$(echo $grids | sed '1,6d')"
    ((i++))
done

#Let's go through the drawn numbers and replace them with "a" in the grids, until one grid has a line or column of "a"
for n in "${drawArr[@]}"; do
    echo ""
    echo "Drawing number $n..."
    for i in {1..${#gridsArr[@]}}; do
        percent=$(( $i * 100 / ${#gridsArr[@]} ))
        echo -ne "Processing grids: $percent%\r\c"
        gridsArr[${i}]="$(echo $gridsArr[${i}] | sed "s/^${n}[[:space:]]/a /" | sed "s/[[:space:]]${n}[[:space:]]/ a /" | sed "s/[[:space:]]${n}$/ a/")"
        for j in {1..5}; do
            if [[ "$(echo $gridsArr[${i}] | sed "${j}q;d")" ==  "$h" || "$(echo $gridsArr[${i}] | awk -v var=$j '{print $var}')" == "$v" ]]; then
                echo ""
                echo "We have a winner!"
                winGrid=$gridsArr[${i}]
                lastNum=$n
                break
            fi
        done
        if [[ "$winGrid" != "" ]]; then
            break
        fi
        echo -ne ""
    done
    if [[ "$winGrid" != "" ]]; then
        break
    fi
done

#Let's strip the "a" from the winning grid
winGrid="$(echo $winGrid | sed 's/a//g')"
echo "Winning grid remaining numbers:"
echo "$winGrid"
echo "Last number drawn: $lastNum"

#Calculate the sum of the numbers in there
sum="$(echo $winGrid | tr ' ' '\n' | awk '/[0-9]+/ {gsub(/[^0-9]/, "", $0); sum+=$0} END {print sum}')"
echo $(( ${sum} * ${lastNum} ))
