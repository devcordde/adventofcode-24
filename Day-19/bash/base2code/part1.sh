#!/bin/bash

INPUT=input.txt

ava=($(head -n 1 $INPUT | sed 's/,//g'))
tbds=$(tail -n+3 $INPUT)

function check () {
        local work=$1
        if [[ ${#work} -eq 0 ]]; then return 0; fi
        for a in ${ava[@]}; do
                local b=${work#"$a"}
                if [[ $b == $work ]]; then continue; fi
                check $b
                if [[ $? -eq 0 ]]; then return 0; fi
        done
        return 1
}

sum=0
for tbd in $tbds; do
        check $tbd
        rc=$?
        if [[ $rc -eq 0 ]]; then
                echo " OK - $tbd"
                sum=$(($sum + 1))
        else
                echo "NOK - $tbd"
        fi
done

echo "Summe: $sum"
