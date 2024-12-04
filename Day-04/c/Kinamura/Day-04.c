#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LINE_SIZE 142
#define LINES 142

int readInput(char prompts[][LINE_SIZE]) {
    FILE *input = fopen("./04input.txt", "r");
    int i = 0;
    if (input != NULL) {
        while (fgets(prompts[i++], LINE_SIZE, input) != NULL) {
        }
    }
    return (fclose(input) & 0) | (i - 1);
}

int checkWord(char input[][LINE_SIZE], int i, int j) {
    int sum = 0;
    if (j+3 < LINE_SIZE && input[i][j+1] == 'M' && input[i][j+2] == 'A' && input[i][j+3] == 'S') sum += 1;
    if (j-3 >= 0 && input[i][j-1] == 'M' && input[i][j-2] == 'A' && input[i][j-3] == 'S') sum += 1;
    if (i+3 < LINES && input[i+1][j] == 'M' && input[i+2][j] == 'A' && input[i+3][j] == 'S') sum += 1;
    if (i-3 >= 0 && input[i-1][j] == 'M' && input[i-2][j] == 'A' && input[i-3][j] == 'S') sum += 1;
    if (i+3 < LINES && j+3 < LINE_SIZE && input[i+1][j+1] == 'M' && input[i+2][j+2] == 'A' && input[i+3][j+3] == 'S') sum += 1;
    if (i-3 >= 0 && j+3 < LINE_SIZE && input[i-1][j+1] == 'M' && input[i-2][j+2] == 'A' && input[i-3][j+3] == 'S') sum += 1;
    if (i+3 < LINES && j-3 >= 0 && input[i+1][j-1] == 'M' && input[i+2][j-2] == 'A' && input[i+3][j-3] == 'S') sum += 1;
    if (i-3 >= 0 && j-3 >= 0 && input[i-1][j-1] == 'M' && input[i-2][j-2] == 'A' && input[i-3][j-3] == 'S') sum += 1;
    return sum;
}

int checkWord2(char input[][LINE_SIZE], int i, int j) {
    int sum = 0;
    if (i-2 >= 0 && j-2 >= 0) {
        if (input[i-1][j-1] == 'A' && input[i-2][j-2] == 'S' && input[i][j-2] == 'M' && input[i-2][j] == 'S') sum += 1;
        if (input[i-1][j-1] == 'A' && input[i-2][j-2] == 'S' && input[i-2][j] == 'M' && input[i][j-2] == 'S') sum += 1;
    }
    if (i-2 >= 0 && j+2 < LINE_SIZE) {
        if (input[i-1][j+1] == 'A' && input[i-2][j+2] == 'S' && input[i][j+2] == 'M' && input[i-2][j] == 'S') sum += 1;
        if (input[i-1][j+1] == 'A' && input[i-2][j+2] == 'S' && input[i-2][j] == 'M' && input[i][j+2] == 'S') sum += 1;
    }
    if (i+2 < LINES && j-2 >= 0) {
        if (input[i+1][j-1] == 'A' && input[i+2][j-2] == 'S' && input[i][j-2] == 'M' && input[i+2][j] == 'S') sum += 1;
        if (input[i+1][j-1] == 'A' && input[i+2][j-2] == 'S' && input[i+2][j] == 'M' && input[i][j-2] == 'S') sum += 1;
    }
    if (i+2 < LINES && j+2 < LINE_SIZE) {
        if (input[i+1][j+1] == 'A' && input[i+2][j+2] == 'S' && input[i][j+2] == 'M' && input[i+2][j] == 'S') sum += 1;
        if (input[i+1][j+1] == 'A' && input[i+2][j+2] == 'S' && input[i+2][j] == 'M' && input[i][j+2] == 'S') sum += 1;
    }
    input[i][j] = '.';
    return sum;
}


void parseInput(const int lines, char input[][LINE_SIZE], int run) {
    int sum = 0;
    for (int i = 0; i < lines; i++) {
        for (int j = 0; j < LINE_SIZE; j++) {
            if (run == 1 && input[i][j] == 'X') sum += checkWord(input, i, j);
            if (run == 2 && input[i][j] == 'M') sum += checkWord2(input, i, j);
        }
    }
    printf("Found %d matches for %s\n", sum, (run == 1) ? "XMAS" : "X-MAS");
}

int main(int argc, char** argv) {
    char input[LINES][LINE_SIZE];
    int lineCount = readInput(input);
    parseInput(lineCount, input, 1);
    parseInput(lineCount, input, 2);
    return 0;
}
