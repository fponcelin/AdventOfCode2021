#!/bin/zsh

# Expecting local txt file path as input

declare -A dotsArr
declare -a foldsArr

while read line
do
    if [[ "$line" =~ , ]]; then
        dotsArr+=( [$line]="#" )
    else
        foldsArr+=( "$line" )
    fi
done <$1

for fold in ${foldsArr[@]}; do
    foldAxis="$(echo "$fold" | awk -F '=' '{print $NF}')"
    for coord in ${(k)dotsArr}; do
        x="$(echo "$coord" | awk -F ',' '{print $1}')"
        y="$(echo "$coord" | awk -F ',' '{print $2}')"
        if [[ "$fold" =~ x || $x -gt $foldAxis ]]; then
            dotsArr[$coord]=""
            xNew=$(( $foldAxis - ( $x - $foldAxis ) ))
            if [[ -z $dotsArr[$xNew,$y] ]]; then
                dotsArr+=( [[$xNew,$y]="#" )
            fi
        elif [[ "$fold" =~ y || $y -gt $foldAxis ]]; then
            dotsArr[$coord]=""
            yNew=$(( $foldAxis - ( $y - $foldAxis ) ))
            if [[ -z $dotsArr[$x,$yNew] ]]; then
                dotsArr+=( [[$x,$yNew]="#" )
            fi
        fi
    done
    
    dotCount=0
    for v in ${(v)dotsArr}; do
        if [[ $v == "#" ]]; then
            ((dotCount++))
        fi
    done
    echo "Count after folding: $dotCount"
    break
done