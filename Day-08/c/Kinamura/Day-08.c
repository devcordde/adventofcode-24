#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define LINE_SIZE 64
#define LINES 64

typedef struct {
    int count;
    int pos[4][2];
} Antenna;

int readInput(char prompts[][LINE_SIZE]){
    FILE *input = fopen("./08input.txt", "r");
    int i = 0;
    if (input != NULL){
        while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
    }
    return (fclose(input) & 0) | (i - 1);
}

void parseInput(char inputs[][LINE_SIZE], int lines, int grid[][LINES], Antenna antennas[]) {
    for (int i = 0; i < lines; i++) {
        for (int j = 0; j < lines; j++) {
            if (inputs[i][j] == '.') continue;
            int offset = 0;
            if (isdigit(inputs[i][j])) offset = '0';
            if (isupper(inputs[i][j])) offset = 'A' - 10;
            if (islower(inputs[i][j])) offset = 'a' - 36;
            antennas[inputs[i][j] - offset].pos[antennas[inputs[i][j] - offset].count][0] = i;
            antennas[inputs[i][j] - offset].pos[antennas[inputs[i][j] - offset].count][1] = j;
            antennas[inputs[i][j] - offset].count++;
        }
    }
}

int getGGT(int i, int j) {
    if (j == 0) return i;
    return getGGT(j, i % j);
}

void markAntinodes(int x1, int y1, int x2, int y2, int lines, int grid[][LINES], int loop) {
    if (loop && grid[x1][y1] < 2 ) grid[x1][y1] += 2;
    while (x1 + x2 >= 0 && y1 + y2 >= 0 && x1 + x2 < lines && y1 + y2 < lines) {
        x1 += x2;
        y1 += y2;
        if (!loop && (grid[x1][y1] == 0 || grid[x1][y1] == 2) ) grid[x1][y1] += 1;
        if (!loop) return;
        if (grid[x1][y1] < 2 ) grid[x1][y1] += 2;
    }
}

void getAntinodes(char inputs[][LINE_SIZE], int lines, int grid[][LINES], Antenna antennas[]) {
    for (int i = 0; i < 62; i++) {
        for (int j = 0; j < antennas[i].count - 1; j++) {
            for (int k = j + 1; k < antennas[i].count; k++) {
                int vector[] = {antennas[i].pos[j][0] - antennas[i].pos[k][0], antennas[i].pos[j][1] - antennas[i].pos[k][1]};
                int ggt = getGGT(vector[0], vector[1]);
                int nVec[] = {vector[0] / ggt, vector[1] / ggt};
                markAntinodes(antennas[i].pos[j][0], antennas[i].pos[j][1], vector[0], vector[1], lines, grid, 0);
                markAntinodes(antennas[i].pos[k][0], antennas[i].pos[k][1], -vector[0], -vector[1], lines, grid, 0);
                markAntinodes(antennas[i].pos[j][0], antennas[i].pos[j][1], nVec[0], nVec[1], lines, grid, 1);
                markAntinodes(antennas[i].pos[k][0], antennas[i].pos[k][1], -nVec[0], -nVec[1], lines, grid, 1);
            }
        }
    }
}

int main() {
    char input[LINES][LINE_SIZE];
    int grid[LINES][LINES] = {0}, sum = 0, sum2 = 0;
    int lineCount = readInput(input);
    Antenna antennas[62];
    parseInput(input, lineCount, grid, antennas);
    getAntinodes(input, lineCount, grid, antennas);
    for (int i = 0; i < lineCount; i++) {
        for (int j = 0; j < lineCount; j++) {
            if (grid[i][j] == 3) sum++;
            if (grid[i][j] > 1) sum2++;
        }
    }
    printf("Antinode positions: %d\nAntinode-line positions: %d\n", sum, sum2);
}
