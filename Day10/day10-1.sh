#!/bin/zsh

# Expecting local txt file path as input
input="$(cat $1)"

declare -A scoreArr
scoreArr=( [")"]=3 ["]"]=57 ["}"]=1197 [">"]=25137 )
lineCount=$(echo "$input" | wc -l | awk '{print $NF}')
errorScore=0


for i in {1..$lineCount}; do
    echo "Finding illegal closing characters: $(( 100 * $i / $lineCount ))%\r\c"
    line="$(echo "$input" | head -n $i | tail -n 1)"

    lineLengthStart=${#line}
    lineLengthEnd=0

    while [[ $lineLengthStart -gt $lineLengthEnd ]]; do
        lineLengthStart=${#line}
        line="$(echo "$line" | sed 's/{}//g' | sed 's/\[\]//g' | sed 's/<>//g' | sed 's/()//g')"
        lineLengthEnd=${#line}
    done
    
    for i in {1..${#line}}; do
        if [[ "$line[$i]" == ")" || "$line[$i]" == "}" || "$line[$i]" == "]" || "$line[$i]" == ">" ]]; then
            errorScore=$(( $errorScore + $scoreArr[$line[$i]] ))
            break
        fi
    done
done

echo ""
echo "Error score: $errorScore"
exit 0