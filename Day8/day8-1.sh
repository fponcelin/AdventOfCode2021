#!/bin/zsh

# Expecting local txt file path as input
# For this task we only need the stuff after the pipe, so let's get that.
input="$(cat $1 | awk -F "|" '{print $NF}')"
count=0

length=$(echo "$input" | wc -l | awk '{print $NF}')
for i in {1..$length}; do
    line="$(echo "$input" | head -n $i | tail -n 1)"
    for o in {1..4}; do
        digit="$(echo "$line" | awk -v var=$o '{print $var}')"
        if [[ ${#digit} -ge 2 && ${#digit} -le 4 || ${#digit} -eq 7 ]]; then
            ((count++))
        fi
    done
done

echo "$count"
exit 0