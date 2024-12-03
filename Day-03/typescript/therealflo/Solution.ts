// Importing the 'readFileSync' function from the 'fs' module to read the input file.
// Note: This could be omitted if the input is hardcoded directly in the program.
import { readFileSync } from "fs";

// Reading the input file and storing its content as a string.
const input = readFileSync("input.txt", "utf-8");

console.log("The solution for part 1 is " + mulSum(input, /mul\(\d{1,3},\d{1,3}\)/g));
console.log("The solution for part 2 is " + mulSum(input, /(mul\()(\d{1,3})(,)(\d{1,3})(\))|(don't\(\))|(do\(\))/g));

function mulSum(input: string, regex: RegExp): number {
    const matches: string[] = input.match(regex) || []; // Explicitly type as string array
    let isActive = true;

    return matches.reduce<number>((sum, match) => {
        if (match === "do()") {
            isActive = true;
        } else if (match === "don't()") {
            isActive = false;
        } else if (isActive) {
            const result = match.match(/mul\((\d{1,3}),(\d{1,3})\)/);
            if (result) {
                const num1 = parseInt(result[1], 10); // Parse the first number
                const num2 = parseInt(result[2], 10); // Parse the second number
                return sum + num1 * num2;
            }
        }
        return sum;
    }, 0); // Start the sum at 0
}