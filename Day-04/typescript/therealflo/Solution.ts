// Importing the 'readFileSync' function from the 'fs' module to read the input file.
// Note: This could be omitted if the input is hardcoded directly in the program.
import { readFileSync } from "fs";

// Reading the input file and storing its content as a string.
const input: string = readFileSync("input.txt", "utf-8");

/**
 * Function to count the occurrences of the word "XMAS" in all possible directions within the grid.
 * 
 * @param grid The 2D array representing the grid to search in.
 * @returns The total number of occurrences of the word "XMAS".
 */
function countXMASOccurrences(grid: string[][]): number {
    const target = "XMAS";  // The word we are searching for in the grid
    
    // Directions array: each object defines a direction (dx, dy) for movement
    // dx is the horizontal movement, dy is the vertical movement
    const directions = [
        { dx: 0, dy: 1 },  // Horizontal right
        { dx: 1, dy: 0 },  // Vertical down
        { dx: 1, dy: 1 },  // Diagonal down-right
        { dx: 1, dy: -1 }, // Diagonal down-left
        { dx: 0, dy: -1 }, // Horizontal left
        { dx: -1, dy: 0 }, // Vertical up
        { dx: -1, dy: -1 },// Diagonal up-left
        { dx: -1, dy: 1 }  // Diagonal up-right
    ];

    const rows = grid.length;
    const cols = grid[0].length;
    let count = 0;

    // Helper function to check if a given position (x, y) is within grid bounds.
    const isValidPosition = (x: number, y: number): boolean =>
        x >= 0 && x < rows && y >= 0 && y < cols;

    /**
     * Helper function to check if the target word ("XMAS") matches starting at position (x, y)
     * in the specified direction (dx, dy).
     * 
     * @param x The starting row index.
     * @param y The starting column index.
     * @param dx The horizontal direction (dx).
     * @param dy The vertical direction (dy).
     * @returns True if "XMAS" matches in the given direction, otherwise false.
     */
    const matchesTarget = (x: number, y: number, dx: number, dy: number): boolean => {
        for (let i = 0; i < target.length; i++) {
            const nx = x + i * dx;
            const ny = y + i * dy;
            if (!isValidPosition(nx, ny) || grid[nx][ny] !== target[i]) {
                return false;
            }
        }
        return true;
    };

    // Loop through each position in the grid and check all directions for matches.
    for (let x = 0; x < rows; x++) {
        for (let y = 0; y < cols; y++) {
            for (const { dx, dy } of directions) {
                if (matchesTarget(x, y, dx, dy)) {
                    count++;
                }
            }
        }
    }

    return count;
}

/**
 * Define all possible "XMAS" patterns (3x3 grid shapes).
 * Each pattern can include placeholders (".") for flexibility in matching.
 */
const XMASSHAPES: string[][][] = [
    [
        ["M", ".", "S"],
        [".", "A", "."],
        ["M", ".", "S"]
    ],
    [
        ["S", ".", "M"],
        [".", "A", "."],
        ["S", ".", "M"]
    ],
    [
        ["M", ".", "M"],
        [".", "A", "."],
        ["S", ".", "S"]
    ],
    [
        ["S", ".", "S"],
        [".", "A", "."],
        ["M", ".", "M"]
    ]
];

/**
 * Function to check if a 3x3 pattern matches the portion of the grid starting at position (x, y).
 * The '.' character in the pattern is a wildcard and can match any character in the grid.
 * 
 * @param grid The 2D grid to check.
 * @param x The starting row index.
 * @param y The starting column index.
 * @param pattern The 3x3 pattern to match.
 * @returns True if the pattern matches the grid portion, otherwise false.
 */
function matchesPattern(grid: string[][], x: number, y: number, pattern: string[][]): boolean {
    for (let i = 0; i < 3; i++) {
        for (let j = 0; j < 3; j++) {
            const gridChar = grid[x + i]?.[y + j];  // The current character in the grid
            // Check if the grid character matches the pattern, or if the pattern has a wildcard
            if (gridChar !== pattern[i][j] && pattern[i][j] !== ".") {
                return false;
            }
        }
    }
    return true;  // Return true if the pattern matches
}

/**
 * Function to count the occurrences of the predefined "XMAS" patterns (3x3).
 * 
 * @param grid The 2D array representing the grid to search in.
 * @returns The total number of occurrences of the "XMAS" patterns.
 */
function countXMASPatterns(grid: string[][]): number {
    const rows = grid.length;
    const cols = grid[0].length;
    let count = 0;

    // Loop through the grid and check all possible 3x3 subgrids for each pattern.
    for (let x = 0; x <= rows - 3; x++) {
        for (let y = 0; y <= cols - 3; y++) {
            for (const pattern of XMASSHAPES) {
                if (matchesPattern(grid, x, y, pattern)) {
                    count++;
                }
            }
        }
    }

    return count;
}

// Convert the input string into a 2D grid of characters.
const grid = input.trim().split("\n").map(line => line.split("")); 

console.log(`The solution for part 1 is ${countXMASOccurrences(grid)}`);
console.log(`The solution for part 2 is ${countXMASPatterns(grid)}`);