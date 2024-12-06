#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LINE_SIZE 132
#define LINES 130

int readInput(char prompts[][LINE_SIZE]) {
    FILE * input = fopen("./06input.txt", "r");
    int i = 0;
    if (input != NULL) {
        while (fgets(prompts[i++], LINE_SIZE, input) != NULL) {}
    }
    return (fclose(input) & 0) | (i - 1);
}

void findStart(const int lines, char input[][LINE_SIZE], int start[]) {
    for (int i = 0; i < lines; i++) {
        for (int j = 0; j < LINE_SIZE - 1; j++) {
            if (input[i][j] == '^') {
                start[0] = i;
                start[1] = j;
                input[i][j] = 'X';
            }
        }
    }
}

void preventCollision(const int lines, char input[][LINE_SIZE], int currPos[], int currDir[]) {
    if (currDir[0] == 0) {
        currDir[0] = currDir[1];
        currDir[1] = 0;
    } else {
        currDir[1] = currDir[0] * (-1);
        currDir[0] = 0;
    }
}

int runPath(const int lines, char input[][LINE_SIZE], int watchX, int watchY, int startX, int startY) {
    int currPos[2] = {
        startX,
        startY
    }, currDir[2] = {
        -1,
        0
    }, sum = 1, loopCheck = 0, runTiles = 0;
    while (1) {
        if (currPos[0] + currDir[0] < 0 || currPos[0] + currDir[0] > lines || currPos[1] + currDir[1] > lines || currPos[1] + currDir[1] < 0) break;
        if (input[currPos[0]][currPos[1]] != 'X') {
            input[currPos[0]][currPos[1]] = 'X';
            sum++;
        }
        if (currPos[0] + currDir[0] == watchX && currPos[1] + currDir[1] == watchY) {
            if (4 < loopCheck++) return 1;
        }
        while (input[currPos[0] + currDir[0]][currPos[1] + currDir[1]] == '#') {
            preventCollision(lines, input, currPos, currDir);
        }
        runTiles++;
        currPos[0] += currDir[0];
        currPos[1] += currDir[1];
        if (runTiles > lines * lines) return 1;
    }
    if (watchX == -1) printf("Part 1: %d\n", sum);
    return 0;
}

void findLoops(const int lines, char input[][LINE_SIZE], int startX, int startY) {
    int sum = 0;
    for (int i = 0; i < lines; i++) {
        for (int j = 0; j < LINE_SIZE - 1; j++) {
            if (input[i][j] == 'X') {
                input[i][j] = '#';
                sum += runPath(lines, input, i, j, startX, startY);
                input[i][j] = 'X';
            }
        }
    }
    printf("Part 2: %d\n", sum);
}

int main(int argc, char ** argv) {
    char input[LINES][LINE_SIZE];
    int lineCount = readInput(input), start[2];
    findStart(lineCount, input, start);
    runPath(lineCount, input, -1, -1, start[0], start[1]);
    findLoops(lineCount, input, start[0], start[1]);
    return 0;
}
