#!/bin/bash

echo "Part 1:"
grep -ohE 'mul\([0-9]*,[0-9]*\)' input.txt | sed 's/mul('//g'' | sed 's/)/+/g' | sed 's/,/*/g' | tr -d '\n' | awk '{print $1"0"}' | while read expr; do echo $((expr)); done

echo "Part 2:"
grep -ohE "(do(n't)*\(\))|(mul\([0-9]*,[0-9]*\))" input.txt | while read line; do if [[ $line =~ t ]]; then action=1; elif [[ $line =~ do ]]; then action=0; else if [[ $action -eq 1 ]]; then continue; fi; echo $line | sed 's/mul('//g'' | sed 's/)/+/g' | sed 's/,/*/g' ; fi; done | tr -d '\n' | awk '{print $1"0"}' | while read expr; do echo $((expr)); done
