// Importing the 'readFileSync' function from the 'fs' module to read the input file.
// Note: This could be omitted if the input is hardcoded directly in the program.
import { readFileSync } from "fs";

// Reading the input file and storing its content as a string.
const input = readFileSync("input.txt", "utf-8");

/**
 * Function to determine if a given report (array of levels) is "safe".
 * A report is safe if:
 * - The difference between adjacent levels is between 1 and 3 (inclusive).
 * - The levels are either all increasing or all decreasing.
 * 
 * @param report - Array of numbers representing the levels in the report.
 * @returns boolean - True if the report is safe, false otherwise.
 */
function isSafe(report: number[]): boolean {
    // Calculate the differences between adjacent levels.
    const diffs = report.slice(1).map((level, i) => level - report[i]);

    // Check if all differences are within the allowed range.
    const validDiffs = diffs.every(diff => Math.abs(diff) >= 1 && Math.abs(diff) <= 3);
    if (!validDiffs) return false;

    // Check if levels are either strictly increasing or strictly decreasing.
    const increasing = diffs.every(diff => diff > 0);
    const decreasing = diffs.every(diff => diff < 0);

    // A report is safe if it is either all increasing or all decreasing.
    return increasing || decreasing;
}

/**
 * Function to determine if a report is "safe" with the option of removing one level (dampener).
 * 
 * @param report - Array of numbers representing the levels in the report.
 * @returns boolean - True if the report can be made safe by removing one level, false otherwise.
 */
function isSafeWithDampener(report: number[]): boolean {
    // First, check if the report is already safe.
    if (isSafe(report)) return true;

    // Try removing each level in the report to see if the modified report is safe.
    for (let i = 0; i < report.length; i++) {
        // Create a new report with the current level removed.
        const modifiedReport = report.slice(0, i).concat(report.slice(i + 1));
        // Check if the modified report is safe.
        if (isSafe(modifiedReport)) return true;
    }

    // Return false if no safe configuration is found.
    return false;
}

// Parse the input data into an array of number arrays.
const lines: number[][] = input.split("\n").map(line => line.split(" ").map(Number));

// Part 1: Count how many reports are safe as per the original rules.
const safeCountPartOne = lines.reduce((count, report) => count + (isSafe(report) ? 1 : 0), 0);
console.log(`The solution for part 1 is ${safeCountPartOne}`);

// Part 2: Count how many reports can be made safe with the dampener rule.
const safeCountPartTwo = lines.reduce((count, report) => count + (isSafeWithDampener(report) ? 1 : 0), 0);
console.log(`The solution for part 2 is ${safeCountPartTwo}`);