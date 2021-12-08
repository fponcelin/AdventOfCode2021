#!/bin/zsh

#Expecting local txt file path as input
input="$(cat $1)"

#I think we're looking for the median, so let's build an array of the values in ascending order
posArr=()
i=0
while [[ "$input" =~ "[0-9]" ]]; do
    if [[ "$input" =~ "^$i," ]]; then
        posArr+=( $i )
        input="$(echo "$input" | sed "s/^$i,/,/")"
    elif [[ "$input" =~ ",$i," ]]; then
        posArr+=( $i )
        input="$(echo "$input" | sed "s/,$i,/,/")"
    elif [[ "$input" =~ ",$i$" ]]; then
        posArr+=( $i )
        input="$(echo "$input" | sed "s/,$i$/,/")"
    else
        ((i++))
    fi
done

#Now let's calculate the median
if [[ "$(( ${#posArr[@]} % 2 ))" -eq 0 ]]; then
    x1=$(( ${#posArr[@]} / 2 ))
    x2=$(( $x1 + 1 ))
    finalPos=$(( ( $posArr[$x1] + $posArr[$x2] ) / 2 ))
else
    x=$(( ( ${#posArr[@]} + 1 ) / 2 ))
    finalPos=$posArr[$x]
fi

#Finally let's calculate the total cost of moving to that position
cost=0
for p in ${posArr[@]}; do
    if [[ $p -lt $finalPos ]]; then
        cost=$(( $cost + $finalPos - $p ))
    else
        cost=$(( $cost + $p - $finalPos ))
    fi
done

echo "Total cost: $cost"