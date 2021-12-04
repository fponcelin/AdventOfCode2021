#!/bin/zsh

#Expecting local txt file path as input
input="$(cat $1)"
oxyGenInput=$input
co2ScrubberInput=$input

bitLength=$(echo $input | head -n 1 | awk '{print length}')

for i in {1..$bitLength}; do
    oxyGenOnesCount="$(echo $oxyGenInput | cut -b $i | sed '/0/d' | wc -l)"
    oxyGenZeroesCount="$(echo $oxyGenInput | cut -b $i | sed '/1/d' | wc -l)"
    co2ScrubOnesCount="$(echo $co2ScrubberInput | cut -b $i | sed '/0/d' | wc -l)"
    co2ScrubZeroesCount="$(echo $co2ScrubberInput | cut -b $i | sed '/1/d' | wc -l)"
    position=$(($i-1))

    if [[ $(echo $oxyGenInput | wc -l) -gt 1 ]]; then
        if [[ $oxyGenOnesCount -ge $oxyGenZeroesCount ]]; then
            oxyGenInput="$(echo $oxyGenInput | sed "/^[[:digit:]]\{$position\}0/d")"
        else
            oxyGenInput="$(echo $oxyGenInput | sed "/^[[:digit:]]\{$position\}1/d")"
        fi
    fi

    if [[ $(echo $co2ScrubberInput | wc -l) -gt 1 ]]; then
        if [[ $co2ScrubZeroesCount -le $co2ScrubOnesCount ]]; then
            co2ScrubberInput="$(echo $co2ScrubberInput | sed "/^[[:digit:]]\{$position\}1/d")"
        else
            co2ScrubberInput="$(echo $co2ScrubberInput | sed "/^[[:digit:]]\{$position\}0/d")"
        fi
    fi

done

echo $(( 2#${oxyGenInput} * 2#${co2ScrubberInput} ))