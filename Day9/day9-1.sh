#!/bin/zsh

# Expecting local txt file path as input
input="$(cat $1)"
sum=0

lineCount=$(echo "$input" | wc -l | awk '{print $NF}')

for i in {1..$lineCount}; do
    echo "Progress: $(( 100 * $i / $lineCount ))% - current sum: $sum\r\c"
    line="$(echo "$input" | head -n $i | tail -n 1)"
    lineAbove=""
    lineBelow=""
    if [[ $i -gt 1 ]]; then
        lineAbove="$(echo "$input" | head -n $(( i-1 )) | tail -n 1)"
    fi
    if [[ $i -lt $lineCount ]]; then
        lineBelow="$(echo "$input" | head -n $(( i+1 )) | tail -n 1)"
    fi

    for j in {1..${#line}}; do
        if [[ $i -eq 1 && $j -eq 1 ]]; then
            if [[ $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineBelow[$j] ]]; then
                sum=$(( $sum + 1 + $line[$j] ))
            fi
        elif [[ $i -eq 1 && $j -eq ${#line} ]]; then
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $lineBelow[$j] ]]; then
                sum=$(( $sum + 1 + $line[$j] ))
            fi
        elif [[ $i -eq 1 ]]; then
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineBelow[$j] ]]; then
                sum=$(( $sum + 1 + $line[$j] ))
            fi
        elif [[ $i -eq $lineCount && $j -eq 1 ]]; then
            if [[ $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineAbove[$j] ]]; then
                sum=$(( $sum + 1 + $line[$j] ))
            fi
        elif [[ $i -eq $lineCount && $j -eq ${#line} ]]; then
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $lineAbove[$j] ]]; then
                sum=$(( $sum + 1 + $line[$j] ))
            fi
        elif [[ $i -eq $lineCount ]]; then
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineAbove[$j] ]]; then
                sum=$(( $sum + 1 + $line[$j] ))
            fi
        elif [[ $j -eq 1 ]]; then
            if [[ $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineBelow[$j] && $line[$j] -lt $lineAbove[$j] ]]; then
                sum=$(( $sum + 1 + $line[$j] ))
            fi
        elif [[ $j -eq ${#line} ]]; then
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $lineBelow[$j] && $line[$j] -lt $lineAbove[$j] ]]; then
                sum=$(( $sum + 1 + $line[$j] ))
            fi
        else
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineAbove[$j] && $line[$j] -lt $lineBelow[$j] ]]; then
                sum=$(( $sum + 1 + $line[$j] ))
            fi
        fi
    done
done

echo ""
echo "Risk level sum: $sum"
exit 0