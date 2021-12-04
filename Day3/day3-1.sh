#!/bin/zsh

#Expecting local txt file path as input
input="$(cat $1)"

bitLength=$(echo $input | head -n 1 | awk '{print length}')
gammaRate=""
epsilonRate=""

for i in {1..$bitLength}; do
    onesCount="$(echo $input | cut -b $i | sed '/0/d' | wc -l)"
    zeroesCount="$(echo $input | cut -b $i | sed '/1/d' | wc -l)"
    if [[ $onesCount -gt $zeroesCount ]]; then
        gammaRate="${gammaRate}1"
        epsilonRate="${epsilonRate}0"
    else
        gammaRate="${gammaRate}0"
        epsilonRate="${epsilonRate}1"
    fi
done

echo "Gamma rate: $gammaRate or $((2#${gammaRate}))"
echo "Epsilon rate: $epsilonRate or $((2#${epsilonRate}))"

echo $(( 2#${gammaRate} * 2#${epsilonRate} ))