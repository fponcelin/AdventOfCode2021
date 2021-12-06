#!/bin/zsh

# First of all, big shoutout to Armin Briegel for his invaluable advice and blog https://scriptingosx.com
# I wouldn't have figured this out without him - in the case of this challenge, this post was especially useful:
# https://scriptingosx.com/2019/11/associative-arrays-in-zsh/

#Expecting local txt file path as input
input="$(cat $1)"
fishArr=(${(@s:,:)input})
day=1

#Let's build a new associative array with quantities of fish per timer value
declare -A fishCountPerTimerArr
fishCountPerTimerArr=( [0]=0 [1]=0 [2]=0 [3]=0 [4]=0 [5]=0 [6]=0 [7]=0 [8]=0 )

for f in ${fishArr[@]}; do
    ((fishCountPerTimerArr[$f]++))
done

#Now let's loop through the days and count the fishes, storing the count in a temp array before putting them back in the main array
while [[ $day -le 256 ]]; do
    echo "Day $day of 256...\r\c"
    
    declare -A tempArr

    for i in {1..8}; do
        let "j = $i - 1"
        tempArr+=( [$j]=$fishCountPerTimerArr[$i] )
    done

    let "fishSix = $fishCountPerTimerArr[0] + $tempArr[6]"
    tempArr+=( [6]=$fishSix [8]=$fishCountPerTimerArr[0] )

    fishCountPerTimerArr=( ${(kv)tempArr} )
    ((day++))
done

fishCount=0
for key value in ${(kv)fishCountPerTimerArr}; do
    ((fishCount+=value))
done

echo ""
echo "Lanternfish count after 256 days: $fishCount"