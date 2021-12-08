#!/bin/zsh

# Expecting local txt file path as input
input="$(cat $1)"

# I have a feeling we're now looking for the mean, so let's just get the values as they are into an array
posArr=(${(@s:,:)input})

# Now let's calculate the mean
total=0
for p in ${posArr[@]}; do
    total=$(( $total + $p ))
done
finalPos=$(( $total / ${#posArr[@]} ))

# Finally let's calculate the total cost of moving to that position
cost=0
for p in ${posArr[@]}; do
    if [[ $p -lt $finalPos ]]; then
        dist=$(( $finalPos - $p ))
    else
        dist=$(( $p - $finalPos ))
    fi
    for i in {1..$dist}; do
        cost=$(( $cost + $i ))
    done
done

echo "Total cost: $cost"