#!/bin/zsh

# Expecting local txt file path as input

declare -A pairsArr
declare -A pairsCountArr
declare -A tempPairsCountArr
declare -A charCountArr

while read line
do
    if [[ "$line" =~ - ]]; then
        pair="$(echo "$line" | awk '{print $1}')"
        char="$(echo "$line" | awk '{print $NF}')"
        pairsArr+=( [$pair]="$char" )

        if [[ -z $charCountArr[$char] ]]; then
            charCountArr+=( [$char]=0 )
        fi

    elif [[ "$line" != "" ]]; then
        polyLength=${#line}
        echo "Polymer: $line"
        firstChar="$line[1]"
        lastChar="$line[${#line}]"

        for i in {1..$(( ${#line}-1 ))}; do
            charLeft="$line[$i]"
            charRight="$line[$(( $i+1 ))]"

            if [[ -z $pairsCountArr[$charLeft$charRight] ]]; then
                pairsCountArr+=( [$charLeft$charRight]=1 )
            else
                pairsCountArr[$charLeft$charRight]=$(( $pairsCountArr[$charLeft$charRight]+1 ))
            fi

            if [[ -z $charCountArr[$charLeft] ]]; then
                charCountArr+=( [$charLeft]=0 )
            fi

            if [[ -z $charCountArr[$charRight] ]]; then
                charCountArr+=( [$charRight]=0 )
            fi

        done
    fi
done <$1


for step in {1..40}; do
    echo "Processing step $step/40...\r\c"
    for pair count in ${(kv)pairsCountArr}; do
        newPairLeft="$pair[1]$pairsArr[$pair]"
        newPairRight="$pairsArr[$pair]$pair[2]"

        if [[ -z $tempPairsCountArr[$newPairLeft] ]]; then
            tempPairsCountArr+=( [$newPairLeft]=$count )
        else
            tempPairsCountArr[$newPairLeft]=$(( $tempPairsCountArr[$newPairLeft]+$count ))
        fi

        if [[ -z $tempPairsCountArr[$newPairRight] ]]; then
            tempPairsCountArr+=( [$newPairRight]=$count )
        else
            tempPairsCountArr[$newPairRight]=$(( $tempPairsCountArr[$newPairRight]+$count ))
        fi
    done

    pairsCountArr=( ${(kv)tempPairsCountArr} )
    tempPairsCountArr=()
done

echo ""
highCount=0
lowCount=0
mostCommon=""
leastCommon=""


for char charCount in ${(kv)charCountArr}; do
    for pair count in ${(kv)pairsCountArr}; do
        if [[ "$pair[1]" == "$char" ]]; then
            charCountArr[$char]=$(( $charCountArr[$char] + $count ))
        fi
    done

    if [[ "$char" == "$lastChar" ]]; then
        charCountArr[$char]=$(( $charCountArr[$char] + 1 ))
    fi

    if [[ $charCountArr[$char] -gt $highCount ]]; then
        highCount=$charCountArr[$char]
        mostCommon="$char"
    elif [[ $charCountArr[$char] -lt $lowCount || $lowCount -eq 0 ]]; then
        lowCount=$charCountArr[$char]
        leastCommon="$char"
    fi
done

echo ""
echo "High count: $highCount ($mostCommon), low count: $lowCount ($leastCommon) Difference: $(( $highCount - $lowCount ))"