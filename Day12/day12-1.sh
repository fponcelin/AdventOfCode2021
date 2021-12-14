#!/bin/zsh

# Expecting local txt file path as input

declare -A linksArr

while read line
do
    cave1="$(echo "$line" | awk -F '-' '{print $1}')"
    cave2="$(echo "$line" | awk -F '-' '{print $2}')"
    if [[ -z $linksArr[$cave1] ]]; then
        linksArr+=( [$cave1]="$cave2" )
    elif [[ ! "$linksArr[$cave1]" =~ $cave2 ]]; then
        linksArr[$cave1]+=" $cave2"
    fi
    if [[ -z $linksArr[$cave2] ]]; then
        linksArr+=( [$cave2]="$cave1" )
    elif [[ ! "$linksArr[$cave2]" =~ $cave1 ]]; then
        linksArr[$cave2]+=" $cave1"
    fi
done <$1

paths=()

startingCaves="$linksArr[start]"
linkCount=$(echo "$startingCaves"| wc -w | awk '{print $NF}')
for i in {1..$linkCount}; do
    paths+=( "start,$(echo "$startingCaves" | awk -v var=$i '{print $var}')" )
done

pathsCount=${#paths[@]}
newPathsCount=$(( $pathsCount +1 ))
extraLoopCount=0
while [[ $pathsCount -ne $newPathsCount && $extraLoopCount -ne 2 ]]; do
    pathsCount=${#paths[@]}
    for i in {1..${#paths[@]}}; do
        for currentCave nextCaves in ${(kv)linksArr}; do
            if [[ "$currentCave" != "start" && "$currentCave" != "end" ]]; then
                if [[ "$currentCave" == "$(echo $paths[$i] | awk -F ',' '{print $NF}')" ]]; then
                    linkCount=$(echo "$nextCaves" | wc -w | awk '{print $NF}')
                    count=1
                    currentPath="$paths[$i]"
                    for j in {1..$linkCount}; do  
                        nextCave="$(echo "$nextCaves" | awk -v var=$j '{print $var}')"
                        if [[ ( ! "$currentPath" =~ $nextCave || $nextCave =~ [A-Z] ) && ! "$currentPath" =~ end ]]; then
                            if [[ $count -eq 1 ]]; then
                                paths[$i]=( "$currentPath,$nextCave" )
                                ((count++))
                            elif [[ "$(echo "$paths" | grep "$currentPath,$nextCave")" == "" ]]; then
                                paths+=( "$currentPath,$nextCave" )
                                newPathsCount=${#paths[@]}
                                extraLoopCount=0
                            fi
                        fi
                    done
                fi
            fi
            echo "Current paths count (incl. dead ends): ${#paths[@]}\r\c"
            
        done
    done
    if [[ $pathsCount -eq $newPathsCount ]]; then
        ((extraLoopCount++))
    fi
done

pathsCount=0
for p in "${paths[@]}"; do
    if [[ "$p" =~ end ]]; then
        ((pathsCount++))
    fi
done
echo ""
echo "Paths count: $pathsCount"
exit 0