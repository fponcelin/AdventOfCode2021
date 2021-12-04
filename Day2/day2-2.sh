#!/bin/zsh

#Expecting local txt file path as input
input="$(cat $1)"

horizontalPos=0
depth=0
aim=0

while [[ $(echo $input | wc -l) -gt 0 && "$input" != "" ]]; do
    command="$(echo $input | head -n 1 | awk '{print $1}')"
    value=$(echo $input | head -n 1 | awk '{print $2}')
    case $command in
        "forward")
            horizontalPos=$(( $horizontalPos + $value ))
            depth=$(( $depth + $aim * $value ))
            ;;
        "down")
            aim=$(( $aim + $value ))
            ;;
        "up")
            aim=$(( $aim - $value ))
            ;;
    esac
    input="$(echo $input | sed '1d')"
done

echo $(( $horizontalPos * $depth ))