#!/bin/zsh

# Expecting local txt file path as input
input="$(cat $1)"
patterns="$(echo "$input" | awk -F "|" '{print $1}' | sed 's/[[:space:]]*$//')"
outputs="$(echo "$input" | awk -F "|" '{print $2}' | sed 's/^[[:space:]]*//')"
declare -A digitFreqSumArr
digitFreqSumArr+=( [42]=0 [17]=1 [34]=2 [39]=3 [30]=4 [37]=5 [41]=6 [25]=7 [49]=8 [45]=9 )
count=0

lineCount=$(echo "$input" | wc -l | awk '{print $NF}')

# Let's try by using the frequency of patterns
for i in {1..$lineCount}; do
    echo "Progress: $(( 100 * $i / $lineCount ))% - current count: $count\r\c"
    line="$(echo "$patterns" | head -n $i | tail -n 1)"

    # Count the amount of each letter
    declare -A countArr
    a="$(echo "$line" | sed 's/[bcdefg[:space:]]*//g')"
    b="$(echo "$line" | sed 's/[acdefg[:space:]]*//g')"
    c="$(echo "$line" | sed 's/[abdefg[:space:]]*//g')"
    d="$(echo "$line" | sed 's/[abcefg[:space:]]*//g')"
    e="$(echo "$line" | sed 's/[abcdfg[:space:]]*//g')"
    f="$(echo "$line" | sed 's/[abcdeg[:space:]]*//g')"
    g="$(echo "$line" | sed 's/[abcdef[:space:]]*//g')"
    countArr+=( [a]=${#a} [b]=${#b} [c]=${#c} [d]=${#d} [e]=${#e} [f]=${#f} [g]=${#g} )
    
    # We have the count of each letter, we can correlate with the known totals to figure out the matching digit
    lineArr=( $(echo "$outputs" | head -n $i | tail -n 1) )
    number=""
    for signal in "${lineArr[@]}"; do
        sum=0
        for j in {1..${#signal}}; do
            sum=$(( $sum + $countArr[$signal[$j]] ))
        done
        number+="$digitFreqSumArr[$sum]"
    done
    ((count+=number))
done

echo ""
echo "Final count: $count"
exit 0