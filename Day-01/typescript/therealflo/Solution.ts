// Import are only needed for the reading of the input, we could ommit that and store the data directly in the code
import { readFileSync } from "fs";

const input = readFileSync("input.txt", "utf-8");

const lines = input.trim().split(`\n`);
const left: number[] = [];
const right: number[] = [];

for (let line of lines) {
    left.push(Number(line.split("   ")[0]));
    right.push(Number(line.split("   ")[1]));
}

left.sort();
right.sort();

let partOneTotal = 0;

for (let i = 0; i < left.length; i++) {
    partOneTotal += Math.abs(left[i] - right[i]);
}

let partTwoTotal = 0;

const counts: Record<string, number> = right.reduce((acc, num) => {
    acc[num] = (acc[num] || 0) + 1;
    return acc;
}, {} as Record<string, number>);

for (let i = 0; i < left.length; i++) {
    partTwoTotal += left[i] * (counts[left[i]] || 0);
}

console.log(`Part 1: ${partOneTotal}`);
console.log(`Part 2: ${partTwoTotal}`);