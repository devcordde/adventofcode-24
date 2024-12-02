package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

type Direction struct {
	Increasing bool
	Decreasing bool
	Unknown    bool
}

func main() {
	content, err := os.ReadFile("input.txt")
	if err != nil {
		fmt.Println("Error reading input file:", err)
		return
	}
	lines := strings.Split(strings.TrimSpace(string(content)), "\n")
	fmt.Println("Part 1:", countSafeReports(lines, false))
	fmt.Println("Part 2:", countSafeReports(lines, true))
}

func countSafeReports(lines []string, allowRemoval bool) int {
	safeCount := 0
	for _, line := range lines {
		if line == "" {
			continue
		}
		nums := ConvertStringArrToIntArr(strings.Fields(line))
		if allowRemoval {
			// Part 2: Try removing each element to see if the sequence becomes safe
			if isSafeWithDamper(nums) {
				safeCount++
			}
		} else {
			// Part 1: Check if the sequence is safe as is
			if isSafe(nums) {
				safeCount++
			}
		}
	}
	return safeCount
}

func isSafe(nums []int) bool {
	if len(nums) < 2 {
		return true
	}
	prev := nums[0]
	dir := Direction{Unknown: true}
	for _, num := range nums[1:] {
		diff := num - prev
		diffAbs := math.Abs(float64(diff))
		if (diff < 0 && dir.Increasing) || (diff > 0 && dir.Decreasing) || diffAbs < 1 || diffAbs > 3 {
			return false
		} else {
			setDirection(&dir, diff)
			prev = num
		}
	}
	return true
}

func isSafeWithDamper(nums []int) bool {
	for i := 0; i < len(nums); i++ {
		modifiedNums := append([]int{}, nums[:i]...)
		modifiedNums = append(modifiedNums, nums[i+1:]...)
		if isSafe(modifiedNums) {
			return true
		}
	}
	return false
}

func setDirection(dir *Direction, diff int) {
	dir.Increasing = false
	dir.Decreasing = false
	dir.Unknown = false
	if diff > 0 {
		dir.Increasing = true
	} else if diff < 0 {
		dir.Decreasing = true
	}
}

func ConvertStringArrToIntArr(arr []string) []int {
	intArr := make([]int, len(arr))
	for i, str := range arr {
		num, err := strconv.Atoi(str)
		if err != nil {
			fmt.Println("Error converting string to int:", err)
			return nil
		}
		intArr[i] = num
	}
	return intArr
}
