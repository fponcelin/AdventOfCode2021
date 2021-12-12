#!/bin/zsh

# Expecting local txt file path as input
input="$(cat $1)"

declare -A octopiArr

for y in {1..10}; do
    line="$(echo "$input" | head -n $y | tail -n 1)"
    for x in {1..10}; do
        octopiArr+=( [$x,$y]=$line[$x] )
    done
done

allFlash=0
step=0
while [[ $allFlash -eq 0 ]]; do
    ((step++))
    echo "Step $step...\r\c"
    
    # Start by incrementing every octopus' energy level
    for key value in ${(kv)octopiArr}; do
        octopiArr[$key]=$(( $value + 1 ))
    done

    # Now we go through octopi and increase the level of octopi adjacent to flashing ones
    flashComplete=0
    while [[ $flashComplete -eq 0 ]]; do
        flashComplete=1
        for key value in ${(kv)octopiArr}; do
            if [[ $value -ge 10 ]]; then
                flashComplete=0
                octopiArr[$key]="F"

                #echo "$key -> $octopiArr[$key]"

                X=$(echo "$key" | awk -F ',' '{print $1}')
                Y=$(echo "$key" | awk -F ',' '{print $2}')

                for x in {$(( $X-1 ))..$(( $X+1 ))}; do
                    for y in {$(( $Y-1 ))..$(( $Y+1 ))}; do
                        if [[ $octopiArr[$x,$y] =~ [0-9] ]]; then
                            octopiArr[$x,$y]=$(( $octopiArr[$x,$y] + 1 ))
                        fi
                    done
                done
            fi
        done
    done

    flashCount=0
    for key value in ${(kv)octopiArr}; do
        if [[ "$value" == "F" ]]; then
            octopiArr[$key]=0
            ((flashCount++))
        fi
    done
    if [[ $flashCount -eq 100 ]]; then
        allFlash=1
    fi
done

echo ""
echo "Step at which they all flash: $step"
exit 0