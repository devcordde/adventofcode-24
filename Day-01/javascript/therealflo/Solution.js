// Import are only needed for the reading of the input, we could ommit that and store the data directly in the code
const fs = require("fs");
const path = require("path");

const input = fs.readFileSync(path.join(__dirname, "input.txt"), "utf-8");

const lines = input.trim().split(`\n`);
let left = [];
let right = [];

for (let line of lines) {
    left.push(line.split("   ")[0]);
    right.push(line.split("   ")[1]);
}

left.sort();
right.sort();

let partOneTotal = 0;

for (let i = 0; i < left.length; i++) {
    partOneTotal += Math.abs(Number(left[i]) - Number(right[i]));
}

let partTwoTotal = 0;

const counts = {};

for (const num of right) {
    counts[num] = counts[num] ? counts[num] + 1 : 1;
}

for (let i = 0; i < left.length; i++) {
    partTwoTotal += Number(left[i]) * (counts[left[i]] || 0);
}

console.log(`Part 1: ${partOneTotal}`);
console.log(`Part 2: ${partTwoTotal}`);