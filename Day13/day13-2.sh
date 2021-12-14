#!/bin/zsh

# Expecting local txt file path as input

declare -A dotsArr
declare -A tempDotsArr
declare -a foldsArr

while read line
do
    if [[ "$line" =~ , ]]; then
        dotsArr+=( [$line]="#" )
    elif [[ "$line" != "" ]]; then
        foldsArr+=( "$line" )
    fi
done <$1

foldCount=1
for fold in ${foldsArr[@]}; do
    echo "Folding: $foldCount/${#foldsArr[@]}...\r\c"
    foldAxis="$(echo "$fold" | awk -F '=' '{print $NF}')"
    for coord in ${(k)dotsArr}; do
        x="$(echo "$coord" | awk -F ',' '{print $1}')"
        y="$(echo "$coord" | awk -F ',' '{print $2}')"
        if [[ "$fold" =~ x && $x -gt $foldAxis ]]; then
            xNew=$(( $foldAxis - ( $x - $foldAxis ) ))
            if [[ -z $tempDotsArr[$xNew,$y] ]]; then
                tempDotsArr+=( [$xNew,$y]="#" )
            fi
        elif [[ "$fold" =~ y && $y -gt $foldAxis ]]; then
            yNew=$(( $foldAxis - ( $y - $foldAxis ) ))
            if [[ -z $tempDotsArr[$x,$yNew] ]]; then
                tempDotsArr+=( [$x,$yNew]="#" )
            fi
        elif [[ -z $tempDotsArr[$coord] ]]; then
            tempDotsArr+=( [$coord]="#" )
        fi
    done
    dotsArr=( ${(kv)tempDotsArr} )
    tempDotsArr=()
    ((foldCount++))

    if [[ "$fold" =~ x ]]; then
        xLastFold=$foldAxis
    else
        yLastFold=$foldAxis
    fi
done

echo ""
echo "Last folding axis: x:$xLastFold, y:$yLastFold"
for y in {0..$yLastFold}; do
    line=""
    for x in {0..$xLastFold}; do
        if [[ -z $dotsArr[$x,$y] ]]; then
            line+="."
        else
            line+="#"
        fi
    done
    echo "$line"
done