package main

import (
	"fmt"
	"math"
	"os"
	"slices"
	"strconv"
	"strings"
)

func main() {
	content, _ := os.ReadFile("Day-01/input.txt")
	lines := strings.Split(strings.ReplaceAll(string(content), "\r\n", "\n"), "\n")
	numsLeft := make([]int, len(lines))
	numsRight := make([]int, len(lines))
	for i, line := range lines {
		arr := strings.Split(line, "   ")
		numsLeft[i], _ = strconv.Atoi(arr[0])
		numsRight[i], _ = strconv.Atoi(arr[1])
	}
	slices.Sort(numsLeft)
	slices.Sort(numsRight)
	fmt.Printf("Day 1 -> Task 1: " + strconv.FormatFloat(sumDiff(numsLeft, numsRight), 'f', 0, 64) + "\n")
	fmt.Printf("Day 1 -> Task 2: " + strconv.FormatInt(int64(simScore(numsLeft, numsRight)), 10))
}

func sumDiff(left, right []int) float64 {
	var sum = 0.0
	for i := 0; i < len(left); i++ {
		sum += math.Abs(float64(left[i] - right[i]))
	}
	return sum
}

func simScore(left []int, right []int) int {
	occurrences := make(map[int]int)
	for _, numL := range left {
		for _, numR := range right {
			if numL == numR {
				occurrences[numL] = occurrences[numL] + 1
			}
		}
		occurrences[numL] = occurrences[numL] * numL
	}
	sum := 0
	for _, val := range occurrences {
		sum += val
	}
	return sum
}
