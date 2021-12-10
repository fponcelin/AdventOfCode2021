#!/bin/zsh

# Expecting local txt file path as input
input="$(cat $1)"

declare -A scoreArr
scoreArr=( ["("]=1 ["["]=2 ["{"]=3 ["<"]=4 )
lineCount=$(echo "$input" | wc -l | awk '{print $NF}')

incompleteLines=""
lineScores=""


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
    
    for j in {1..${#line}}; do
        if [[ "$line[$j]" == ")" || "$line[$j]" == "}" || "$line[$j]" == "]" || "$line[$j]" == ">" ]]; then
            break
        elif [[ $j -eq ${#line} && $line != "" ]]; then
            incompleteLines+="$line\n"
        fi
    done
done

echo ""
lineCount=$(echo "$incompleteLines" | wc -l | awk '{print $NF}')
((lineCount--))
for i in {1..$lineCount}; do
    echo "Closing incomplete lines: $(( 100 * $i / $lineCount ))%\r\c"
    line="$(echo "$incompleteLines" | head -n $i | tail -n 1)"
    lineCompletionScore=0

    for j in {${#line}..1}; do
        lineCompletionScore=$(( $lineCompletionScore * 5 + $scoreArr[$line[$j]] ))
    done
    if [[ $i -lt $lineCount ]]; then
        lineScores+="$lineCompletionScore\n"
    else
        lineScores+="$lineCompletionScore"
    fi
done

#Now we sort the scores and find the middle one
sortedScores="$(echo $lineScores | sort -n)"

echo "$sortedScores" > /Users/zwd148/Documents/lines.txt
l=$(( ( $(echo "$sortedScores" | wc -l | awk '{print $NF}') + 1 ) / 2 ))

echo ""
echo "Middle score: $(echo $sortedScores | head -n $l | tail -n 1)"
exit 0