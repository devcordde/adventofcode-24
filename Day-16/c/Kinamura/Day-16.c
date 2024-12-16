#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LINE 141
typedef struct step {
    int x,y,dir,sum;
} Step;

void readInput(char map[LINE][LINE], int minDist[LINE][LINE][4]) {
    FILE *file = fopen("./16input.txt", "r");
    for (int x = 0; x < LINE; x++) {
        for (int y = 0; y < LINE; y++) {
            fscanf(file, "%c ", &map[x][y]);
            for (int d = 0; d < 4; d++) {
                minDist[x][y][d] = 100000;
            }
        }
    }
    fclose(file);
}

int mod(int a, int b) {
    return (a % b < 0) ? b + a % b : a % b;
}

int findPaths(char map[LINE][LINE], int minDist[LINE][LINE][4]) {
    Step moves[LINE * LINE];
    int mvCount = 1, sum = 0;
    moves[0] = (Step){LINE - 2, 1, 1, 0};
    while (mvCount) {
        int bestIndex = 0;
        for (int i = 1; i < mvCount; i++) {
            if (moves[i].sum < moves[bestIndex].sum) bestIndex = i;
        }
        Step bestStep = moves[bestIndex];
        moves[bestIndex] = moves[--mvCount];
        int x = bestStep.x, y = bestStep.y, dir = bestStep.dir;
        sum = bestStep.sum;
        if (map[x][y] == 'E') break;
        if (map[x][y] == '#' || sum >= minDist[x][y][dir]) continue;
        minDist[x][y][dir] = sum;
        moves[mvCount++] = (Step){x, y, mod(dir + 1, 4), sum + 1000};
        moves[mvCount++] = (Step){x, y, mod(dir - 1, 4), sum + 1000};
        moves[mvCount++] = (Step){x - (dir == 0), y + (dir == 1), dir, sum + 1};
        moves[mvCount++] = (Step){x + (dir == 2), y - (dir == 3), dir, sum + 1};
    }
    return sum;
}

int markPaths(char map[LINE][LINE], int spotMap[LINE][LINE], int md[LINE][LINE][4], int x, int y, int dir, int sum, int tar) {
    int dirs[4][2] = {{-1, 0}, {0, 1}, {1, 0}, {0, -1}};
    if (sum == tar && map[x][y] == 'E') return 1;
    if (sum >= tar || map[x][y] == '#' || sum > md[x][y][dir]) return 0;
    md[x][y][dir] = sum;
    int isBest = 0;
    isBest = markPaths(map, spotMap, md, x + dirs[dir][0], y + dirs[dir][1], dir, sum + 1, tar);
    if (markPaths(map, spotMap, md, x, y, mod(dir + 1, 4), sum + 1000, tar)) isBest = 1;
    if (markPaths(map, spotMap, md, x, y, mod(dir - 1, 4), sum + 1000, tar)) isBest = 1;
    if (isBest) spotMap[x][y] = 1;
    return isBest;
}

int findAllPaths(int sum, char map[LINE][LINE], int spotMap[LINE][LINE], int minDist[LINE][LINE][4]) {
    int spots = 0;
    markPaths(map, spotMap, minDist, LINE - 2, 1, 1, 0, sum);
    for (int r = 0; r < LINE; r++) {
        for (int c = 0; c < LINE; c++) {
            if (spotMap[r][c]) spots++;
        }
    }
    return spots;
}

int main(int argc, char** argv) {
    char map[LINE][LINE];
    int spotMap[LINE][LINE] = {0}, minDist[LINE][LINE][4];
    readInput(map, minDist);
    int sum = findPaths(map, minDist);
    printf("%d\n", sum);
    printf("%d\n", findAllPaths(sum, map, spotMap, minDist) + 1);
    return 0;
}
