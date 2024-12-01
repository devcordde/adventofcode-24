package main

import (
	"fmt"
	"math"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	content, _ := os.ReadFile("input.txt")
	lines := strings.Split(string(content), "\n")
	var left = make([]int, len(lines))
	var right = make([]int, len(lines))
	for i, line := range lines {
		split := strings.Split(line, "   ")
		left[i], _ = strconv.Atoi(split[0])
		right[i], _ = strconv.Atoi(split[1])
	}
	sort.Ints(left)
	sort.Ints(right)
	fmt.Println("Part 1:", part1(left, right))
	fmt.Println("Part 2:", part2(left, right))
}

func part1(left, right []int) int {
	distance := 0
	for i := 0; i < len(left); i++ {
		dis := math.Abs(float64(right[i] - left[i]))
		distance += int(dis)
	}
	return distance
}

func part2(left, right []int) int {
	cache := make(map[int]int)
	similarity := 0
	for _, leftnum := range left {
		if sim, ok := cache[leftnum]; ok {
			similarity += sim
		} else {
			count := 0
			for _, num := range right {
				if num == leftnum {
					count++
				}
			}
			cache[leftnum] = count * leftnum
			similarity += cache[leftnum]
		}
	}
	return similarity
}
