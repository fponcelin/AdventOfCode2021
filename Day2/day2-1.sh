#!/bin/zsh

#Expecting local txt file path as input
input="$(cat $1)"

horizontalPos=0
depth=0

while [[ $(echo $input | wc -l) -gt 0 && "$input" != "" ]]; do
    command="$(echo $input | head -n 1 | awk '{print $1}')"
    value=$(echo $input | head -n 1 | awk '{print $2}')
    #echo "$command $value"
    case $command in
        "forward")
            horizontalPos=$(( $horizontalPos + $value ))
            #echo "Horizontal position: $horizontalPos"
            ;;
        "down")
            depth=$(( $depth + $value ))
            #echo "Depth: $depth"
            ;;
        "up")
            depth=$(( $depth - $value ))
            #echo "Depth: $depth"
            ;;
    esac
    input="$(echo $input | sed '1d')"
    #echo "Remaining length: $(echo $input | wc -l)"
done

echo $(( $horizontalPos * $depth ))