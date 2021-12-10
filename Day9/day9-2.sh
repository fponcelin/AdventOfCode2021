#!/bin/zsh

# Expecting local txt file path as input
input="$(cat $1)"
s1=0
s2=0
s3=0

lowPointCoordsArr=()

lineCount=$(echo "$input" | wc -l | awk '{print $NF}')

for i in {1..$lineCount}; do
    echo "Finding low points: $(( 100 * $i / $lineCount ))%\r\c"
    line="$(echo "$input" | head -n $i | tail -n 1)"
    lineAbove=""
    lineBelow=""
    if [[ $i -gt 1 ]]; then
        lineAbove="$(echo "$input" | head -n $(( i-1 )) | tail -n 1)"
    fi
    if [[ $i -lt $lineCount ]]; then
        lineBelow="$(echo "$input" | head -n $(( i+1 )) | tail -n 1)"
    fi

    for j in {1..${#line}}; do
        if [[ $i -eq 1 && $j -eq 1 ]]; then
            if [[ $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineBelow[$j] ]]; then
                lowPointCoordsArr+=( "$j $i" )
            fi
        elif [[ $i -eq 1 && $j -eq ${#line} ]]; then
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $lineBelow[$j] ]]; then
                lowPointCoordsArr+=( "$j $i" )
            fi
        elif [[ $i -eq 1 ]]; then
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineBelow[$j] ]]; then
                lowPointCoordsArr+=( "$j $i" )
            fi
        elif [[ $i -eq $lineCount && $j -eq 1 ]]; then
            if [[ $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineAbove[$j] ]]; then
                lowPointCoordsArr+=( "$j $i" )
            fi
        elif [[ $i -eq $lineCount && $j -eq ${#line} ]]; then
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $lineAbove[$j] ]]; then
                lowPointCoordsArr+=( "$j $i" )
            fi
        elif [[ $i -eq $lineCount ]]; then
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineAbove[$j] ]]; then
                lowPointCoordsArr+=( "$j $i" )
            fi
        elif [[ $j -eq 1 ]]; then
            if [[ $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineBelow[$j] && $line[$j] -lt $lineAbove[$j] ]]; then
                lowPointCoordsArr+=( "$j $i" )
            fi
        elif [[ $j -eq ${#line} ]]; then
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $lineBelow[$j] && $line[$j] -lt $lineAbove[$j] ]]; then
                lowPointCoordsArr+=( "$j $i" )
            fi
        else
            if [[ $line[$j] -lt $line[$(( $j-1 ))] && $line[$j] -lt $line[$(( $j+1 ))] && $line[$j] -lt $lineAbove[$j] && $line[$j] -lt $lineBelow[$j] ]]; then
                lowPointCoordsArr+=( "$j $i" )
            fi
        fi
    done
done

echo ""
for i in {1..${#lowPointCoordsArr[@]}}; do
    complete=0
    size=0
    x=$(echo $lowPointCoordsArr[$i] | awk '{print $1}')
    y=$(echo $lowPointCoordsArr[$i] | awk '{print $2}')
    pointsToVisit="$x,$y,u|"
    j=1
    while [[ "$pointsToVisit" =~ u ]]; do    
        echo "Finding basins sizes: $(( 100 * $i / ${#lowPointCoordsArr[@]} ))% - current basin's size: $size\r\c"
        currentSize=${#pointsToVisit}
 
        x=$(echo "$pointsToVisit" | awk -F '|' -v var=$j '{print $var}' | awk -F ',' '{print $1}')
        y=$(echo "$pointsToVisit" | awk -F '|' -v var=$j '{print $var}' | awk -F ',' '{print $2}')

        line="$(echo "$input" | head -n $y | tail -n 1)"
        pointsToVisit="$(echo "$pointsToVisit" | sed "s/$x,$y,u/$x,$y,v/")"
        ((size++))

        lineAbove=""
        lineBelow=""
        if [[ $y -gt 1 ]]; then
            lineAbove="$(echo "$input" | head -n $(( $y-1 )) | tail -n 1)"
        fi
        if [[ $y -lt $lineCount ]]; then
            lineBelow="$(echo "$input" | head -n $(( $y+1 )) | tail -n 1)"
        fi

        regex="$(( $x-1 )),$y"
        if [[ $x -gt 1 && $line[$(( $x-1 ))] != "9" && ! "$pointsToVisit" =~ $regex ]]; then
            pointsToVisit+="$(( $x-1 )),$y,u|"
        fi
        regex="$(( $x+1 )),$y"
        if [[ $x -lt ${#line} && $line[$(( $x+1 ))] != "9" && ! "$pointsToVisit" =~ $regex ]]; then
            pointsToVisit+="$(( $x+1 )),$y,u|"
        fi
        regex="$x,$(( $y-1 ))"
        if [[ $y -gt 1 && $lineAbove[$x] != "9" && ! "$pointsToVisit" =~ $regex ]]; then
            pointsToVisit+="$x,$(( $y-1 )),u|"
        fi
        regex="$x,$(( $y+1 ))"
        if [[ $y -lt $lineCount && $lineBelow[$x] != "9" && ! "$pointsToVisit" =~ $regex ]]; then
            pointsToVisit+="$x,$(( $y+1 )),u|"
        fi
        ((j++))
    done

    if [[ $size -ge $s3 ]]; then
        s3=$size
    fi
    if [[ $size -ge $s2 ]]; then
        s3=$s2
        s2=$size
    fi
    if [[ $size -ge $s1 ]]; then
        s3=$s2
        s2=$s1
        s1=$size
    fi
done

echo ""
echo "Biggest basins multiplied: $(( $s1 * $s2 * $s3 ))"
exit 0