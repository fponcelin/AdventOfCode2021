#!/bin/zsh

#Expecting local txt file path as input
input="$(cat $1)"

#Convert the input string to an array of coordinate strings, only adding the ones with equal x or y coordinates
i=1
declare -a coordsArr
while [ "$input" != "" ]; do
    if [[ "$(echo $input | head -n 1 | awk -F ',' '{print $1}')" ==  "$(echo $input | head -n 1 | awk '{print $3}' | awk -F ',' '{print $1}')" || "$(echo $input | head -n 1 | awk -F ',' '{print $2}' | awk '{print $1}')" ==  "$(echo $input | head -n 1 | awk -F ',' '{print $3}')" ]]; then
        coordsArr[$i]="$(echo $input | head -n 1)"
        ((i++))
    fi
    input="$(echo $input | sed '1d')"
done

#Create an associative array to store dangerous coordinates as keys and count as value
declare -A dangerArr
dangerCount=0

#The logic below is not super clean and could be DRYer - but it works, so ¯\_(ツ)_/¯
for c in "${coordsArr[@]}"; do
    #Let's begin with horizontal lines
    if [[ "$(echo $c | awk -F ',' '{print $1}')" == "$(echo $c | awk '{print $3}' | awk -F ',' '{print $1}')" ]]; then
        x="$(echo $c | awk -F ',' '{print $1}')"
        #Compare the y values to substract correctly
        y1="$(echo $c | awk -F ',' '{print $2}' | awk '{print $1}')"
        y2="$(echo $c | awk -F ',' '{print $3}')"
        if [[ "$y1" -gt "$y2" ]]; then
            while [ "$y1" -ge "$y2" ]; do
                if [[ -z "$dangerArr[$x,$y1]" ]]; then
                    dangerArr+=( [$x,$y1]=1 )
                else
                    ((dangerArr[$x,$y1]++))
                    if [[ $dangerArr[$x,$y1] -eq 2 ]]; then
                        ((dangerCount++))
                    fi
                fi
                ((y1--))
            done
        else
            while [ "$y1" -le "$y2" ]; do
                if [[ -z "$dangerArr[$x,$y1]" ]]; then
                    dangerArr+=( [$x,$y1]=1 )
                else
                    ((dangerArr[$x,$y1]++))
                    if [[ $dangerArr[$x,$y1] -eq 2 ]]; then
                        ((dangerCount++))
                    fi
                fi
                ((y1++))
            done
        fi
    else
        #horizontal values are not equal, therefore vertical values must be
        y="$(echo $c | awk -F ',' '{print $3}')"
        #Compare the x values to substract correctly
        x1="$(echo $c | awk -F ',' '{print $1}')"
        x2="$(echo $c | awk '{print $3}' | awk -F ',' '{print $1}')"
        if [[ "$x1" -gt "$x2" ]]; then
            while [ "$x1" -ge "$x2" ]; do
                if [[ -z "$dangerArr[$x1,$y]" ]]; then
                    dangerArr+=( [$x1,$y]=1 )
                else
                    ((dangerArr[$x1,$y]++))
                    if [[ $dangerArr[$x1,$y] -eq 2 ]]; then
                        ((dangerCount++))
                    fi
                fi
                ((x1--))
            done
        else
            while [ "$x1" -le "$x2" ]; do
                if [[ -z "$dangerArr[$x1,$y]" ]]; then
                    dangerArr+=( [$x1,$y]=1 )
                else
                    ((dangerArr[$x1,$y]++))
                    if [[ $dangerArr[$x1,$y] -eq 2 ]]; then
                        ((dangerCount++))
                    fi
                fi
                ((x1++))
            done
        fi
    fi
done

echo "Total point where 2+ lines overlap: $dangerCount"