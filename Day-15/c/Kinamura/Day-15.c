#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 1024
int startRow = -1, rows = 0, currX, currY, robotX, robotY;

void move(char grid[SIZE][SIZE], char c) {
    int dirX = (c == '>') - (c == '<');
    int dirY = (c == 'v') - (c == '^');
    int tempX = currX + dirX, tempY = currY + dirY;
    while (grid[tempY][tempX] == 'O') {
        tempY += dirY;
        tempX += dirX;
    }
    if (grid[tempY][tempX] == '#') return;
    while (tempY != currY || tempX != currX) {
        grid[tempY][tempX] = grid[tempY - dirY][tempX - dirX];
        tempY = tempY - dirY;
        tempX = tempX - dirX;
    }
    currY += dirY;
    currX += dirX;
}

int checkVert(char grid2[SIZE][SIZE], int x, int y, int dirY) {
    if (grid2[y + dirY][x] == '#') return 1;
    if (grid2[y + dirY][x] == '.') return 0;
    return checkVert(grid2, x, y + dirY, dirY) + checkVert(grid2, x + (grid2[y + dirY][x] == '[' ? 1 : -1), y + dirY, dirY);
}

void moveVert(char grid2[SIZE][SIZE], int x, int y, int dirY) {
    if (grid2[y + dirY][x] == '[' || grid2[y + dirY][x] == ']') {
        moveVert(grid2, x + ((grid2[y + dirY][x] == '[') ? 1 : -1), y + dirY, dirY);
        moveVert(grid2, x, y + dirY, dirY);
    }
    grid2[y + dirY][x] = grid2[y][x];
    if (grid2[y][x] == '@') robotY = y + dirY;
    grid2[y][x] = '.';
}

void move2(char grid2[SIZE][SIZE], int x, int y, char c) {
    int dirX = (c == '>') - (c == '<');
    int dirY = (c == 'v') - (c == '^');
    int tempX;
    if (dirY == 0) {
        tempX = x;
        while (grid2[y][tempX + dirX] == '[' || grid2[y][tempX + dirX] == ']') tempX += dirX;
        if (grid2[y][tempX + dirX] == '#') return;
        while (tempX != x) {
            grid2[y][tempX + dirX] = grid2[y][tempX];
            tempX -= dirX;
        }
        grid2[y][x + dirX] = grid2[y][x];
        robotX = x + dirX;
        grid2[y][x] = '.';
    } else {
        if (checkVert(grid2, x, y, dirY) == 0) moveVert(grid2, x, y, dirY);
    }
}

void smallWarehouse(char grid[SIZE][SIZE]) {
    FILE * fp = fopen("./15input.txt", "r");
    char * p;
    while (fscanf(fp, "%s", grid[rows]) == 1) {
        if ((p = strchr(grid[rows], '@'))) {
            currX = p - grid[rows];
            currY = rows;
        }
        if (strchr(grid[rows], '<') && startRow == -1) startRow = rows;
        rows++;
    }
    fclose(fp);
    for (int i = startRow; i < rows; i++) {
        for (int j = 0; j < (int) strlen(grid[i]); j++) {
            move(grid, grid[i][j]);
        }
    }
}

void bigWarehouse(char grid2[SIZE][SIZE]) {
    FILE * fp = fopen("./15input.txt", "r");
    int d;
    char buff[SIZE];
    while (fscanf(fp, "%s", buff) == 1) {
        if (strchr(buff, '<') && startRow == -1) startRow = rows;
        if (startRow == -1) {
            d = 0;
            for (int i = 0; i < (int)strlen(buff); i++) {
                if (buff[i] == '@') {
                    robotX = d;
                    robotY = rows;
                    grid2[rows][d++] = '@';
                    grid2[rows][d++] = '.';
                } else if (buff[i] == 'O') {
                    grid2[rows][d++] = '[';
                    grid2[rows][d++] = ']';
                } else {
                    grid2[rows][d++] = buff[i];
                    grid2[rows][d++] = buff[i];
                }
            }
            grid2[rows][d] = '\0';
        } else {
            strcpy(grid2[rows], buff);
        }
        rows++;
    }
    fclose(fp);
    for (int i = startRow; i < rows; i++) {
        for (int j = 0; j < (int)strlen(grid2[i]); j++) {
            move2(grid2, robotX, robotY, grid2[i][j]);
        }
    }
}

int main(int argc, char ** argv) {
    char grid[SIZE][SIZE], grid2[SIZE][SIZE];
    smallWarehouse(grid);
    int sum = 0;
    for (int i = 0; i < startRow; i++) {
        for (int j = 0; j < (int)strlen(grid[i]); j++) {
            if (grid[i][j] == 'O') sum += 100 * i + j;
        }
    }
    printf("%d\n", sum);
    startRow = -1;
    rows = 0;
    bigWarehouse(grid2);
    sum = 0;
    for (int i = 0; i < startRow; i++) {
        for (int j = 0; j < (int) strlen(grid2[i]); j++) {
            if (grid2[i][j] == '[') sum += 100 * i + j;
        }
    }
    printf("%d\n", sum);
    return 0;
}
