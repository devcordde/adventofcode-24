#!/bin/bash

INPUT=input.txt

declare -A grid
X=()
A=()

count=0
y=0

while read -r line; do
        len=${#line}
        for ((x = 0; x < len; x++)); do
                char=${line:x:1}
                grid["$x,$y"]="$char"
                if [[ $char == "X" ]]; then X+=("$x,$y"); fi
                if [[ $char == "A" ]]; then A+=("$x,$y"); fi
        done
        y=$((y+1))
done < $INPUT

# dirX dirY origin
function checkP1() {
        ori=(${3//,/ })
        M="${grid[$((${ori[0]} + 1*$1)),$((${ori[1]} + 1*$2))]}"
        A="${grid[$((${ori[0]} + 2*$1)),$((${ori[1]} + 2*$2))]}"
        S="${grid[$((${ori[0]} + 3*$1)),$((${ori[1]} + 3*$2))]}"
        if [[ $M == "M" ]] && [[ $A == "A" ]] && [[ $S == "S" ]]; then count=$((count+1)); fi
}

# origin
function checkP2() {
        ori=(${1//,/ })
        UL="${grid[$((${ori[0]} - 1)),$((${ori[1]} + 1))]}"
        UR="${grid[$((${ori[0]} + 1)),$((${ori[1]} + 1))]}"
        LL="${grid[$((${ori[0]} - 1)),$((${ori[1]} - 1))]}"
        LR="${grid[$((${ori[0]} + 1)),$((${ori[1]} - 1))]}"
        case "$UL$LR$UR$LL" in MSSM|SMMS|MSMS|SMSM) count=$((count+1)) ;; esac
}

# Part 1
for startPos in ${X[@]}; do
        checkP1 1 0 "$startPos"
        checkP1 -1 0 "$startPos"
        checkP1 0 1 "$startPos"
        checkP1 0 -1 "$startPos"
        checkP1 1 -1 "$startPos"
        checkP1 -1 1 "$startPos"
        checkP1 -1 -1 "$startPos"
        checkP1 1 1 "$startPos"
done
echo "Part 1: $count"

# Part 2
count=0
for startPos in ${A[@]}; do
        checkP2 $startPos
done
echo "Part 2: $count"
