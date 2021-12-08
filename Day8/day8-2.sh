#!/bin/zsh

# Expecting local txt file path as input
input="$(cat $1)"
patterns="$(echo "$input" | awk -F "|" '{print $1}' | sed 's/[[:space:]]*$//')"
outputs="$(echo "$input" | awk -F "|" '{print $2}' | sed 's/^[[:space:]]*//')"
count=0

lineCount=$(echo "$input" | wc -l | awk '{print $NF}')

# So this works, but is quite slow!
for i in {1..$lineCount}; do
    echo "Progress: $(( 100 * $i / $lineCount ))% - current count: $count\r\c"
    lineArr=( $(echo "$patterns" | head -n $i | tail -n 1) )

    # Identify and save digits 1, 4, 7 and 8, along with patterns for 2,3,5 and 6,9,0 together
    declare -A numArr

    for signal in "${lineArr[@]}"; do
        case ${#signal} in
            2)
                numArr+=( [1]="$signal" )
                ;;
            3)
                numArr+=( [7]="$signal" )
                ;;
            4)
                numArr+=( [4]="$signal" )
                ;;
            5)
                if [[ -z $numArr[235] ]]; then
                    numArr+=( [235]="$signal" )
                else
                    numArr[235]+=" $signal"
                fi
                ;;
            6)
                if [[ -z $numArr[690] ]]; then
                    numArr+=( [690]="$signal" )
                else
                    numArr[690]+=" $signal"
                fi
                ;;
            7)
                numArr+=( [8]="$signal" )
                ;;
        esac
    done

    # Now use that info to deduct the remaining digits
    patternsArr=( $(echo "$numArr[235]") )
    for signal in "${patternsArr[@]}"; do
        r="$(echo $signal | sed "s/[$numArr[1]]//g")"
        if [[ ${#r} -eq 3 ]]; then
            numArr+=( [3]="$signal" )
        fi
    done

    patternsArr=( $(echo "$numArr[690]") )
    for signal in "${patternsArr[@]}"; do
        r="$(echo $signal | sed "s/[$numArr[3]]//g")"
        if [[ ${#r} -eq 1 ]]; then
            numArr+=( [9]="$signal" )
        fi
    done

    patternsArr=( $(echo "$numArr[235]") )
    for signal in "${patternsArr[@]}"; do
        r="$(echo $signal | sed "s/[$numArr[9]]//g")"
        if [[ ${#r} -eq 1 ]]; then
            numArr+=( [2]="$signal" )
        elif [[ ! $signal =~ ^[$numArr[3]]*$ ]]; then
            numArr+=( [5]="$signal" )
        fi
    done

    patternsArr=( $(echo "$numArr[690]") )
    for signal in "${patternsArr[@]}"; do
        r="$(echo $signal | sed "s/[$numArr[5]]//g")"
        if [[ ${#r} -eq 2 ]]; then
            numArr+=( [0]="$signal" )
        elif [[ ! $signal =~ ^[$numArr[9]]*$ ]]; then
            numArr+=( [6]="$signal" )
        fi
    done
    
    # We now know which pattern correspond to which digit, now let's figure out the outputs and add them together...
    lineArr=( $(echo "$outputs" | head -n $i | tail -n 1) )
    number=""
    for signal in "${lineArr[@]}"; do
        for j in {0..9}; do
            if [[ "$signal" =~ ^[$numArr[$j]]*$ && ${#signal} -eq ${#numArr[$j]} ]]; then
                number+="$j"
            fi
        done
    done
    ((count+=number))
done

echo ""
echo "Final count: $count"
exit 0