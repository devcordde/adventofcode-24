#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LINE_SIZE 3500
#define LINES 6

int readInput(char prompts[][LINE_SIZE]) {
    FILE *input = fopen("./03input.txt", "r");
    int i = 0;
    if (input != NULL) {
        while (fgets(prompts[i++], LINE_SIZE, input) != NULL) {
        }
    }
    return (fclose(input) & 0) | (i - 1);
}

void parseInput(const int lines, char input[][LINE_SIZE], int checkReading) {
    int sum = 0, reading = 1;
    for (int i = 0; i < lines; i++) {
        int running = 0, num1 = 0, num2 = 0;
        for (int j = 0;; j++) {
            if (input[i][j] == '\n') break;
            if (checkReading && input[i][j] == 'd') {
                if (input[i][j + 2] == 'n') { reading = 0; continue; }
                else 						{ reading = 1; continue; }
            }
            if (reading == 1 && input[i][j] == 'l' && input[i][j - 1] == 'u' && input[i][j - 2] == 'm') {
                running = 1;
                continue;
            }
            if (running == 1) {
                if (input[i][j] == '(') {
                    running = 2;
                    continue;
                } else {
                    running = 0;
                }
            }
            if (running == 2) {
                if (isdigit(input[i][j])) {
                    num1 = 10 * num1 + (input[i][j] - '0');
                } else if (input[i][j] == ',' && num1 > 0) {
                    running = 3;
                    continue;
                } else {
                    running = 0;
                    num1 = 0;
                }
            }
            if (running == 3) {
                if (isdigit(input[i][j])) {
                    num2 = 10 * num2 + (input[i][j] - '0');
                } else if (input[i][j] == ')' && num2 > 0) {
                    sum += num1 * num2;
                    num1 = 0;
                    num2 = 0;
                    running = 0;
                } else {
                    running = 0;
                    num1 = 0;
                    num2 = 0;
                }
            }
        }
    }
    printf("Part %d: %d.\n", (checkReading) ? 2 : 1, sum);
}

int main(int argc, char *argv[]) {
    char input[LINES][LINE_SIZE];
    const int lineCount = readInput(input);
    parseInput(lineCount, input, 0);
    parseInput(lineCount, input, 1);
    return 0;
}
