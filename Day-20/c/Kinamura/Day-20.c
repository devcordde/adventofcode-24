#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define LINE_SIZE 143
#define LINES 142

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen("./20input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void findStart(char input[][LINE_SIZE], int pos[2]){
	for (int i = 0; i < LINES; i++){
        for (int j = 0; j < LINE_SIZE; j++){
            if (input[i][j] == 'S'){
                pos[0] = i;
                pos[1] = j;
                return;
            }
        }
	}
}

void fillPath(char input[][LINE_SIZE], int distGrid[][LINE_SIZE], int x, int y, int time){
	distGrid[x][y] = time;
    if (input[x][y] == 'E') return;
    if (input[x-1][y] != '#' && distGrid[x-1][y] == 0) fillPath(input, distGrid, x-1, y, time+1);
	if (input[x+1][y] != '#' && distGrid[x+1][y] == 0) fillPath(input, distGrid, x+1, y, time+1);
	if (input[x][y-1] != '#' && distGrid[x][y-1] == 0) fillPath(input, distGrid, x, y-1, time+1);
	if (input[x][y+1] != '#' && distGrid[x][y+1] == 0) fillPath(input, distGrid, x, y+1, time+1);
}

void countCheats(int distGrid[][LINE_SIZE], int x, int y, int sum[2]){
    if (x - 2 >= 0 && distGrid[x-2][y] != 0 && distGrid[x-2][y] - (distGrid[x][y]+2) >= 100) sum[0]++;
	if (x + 2 < LINES && distGrid[x+2][y] != 0 && distGrid[x+2][y] - (distGrid[x][y]+2) >= 100) sum[0]++;
	if (y - 2 >= 0 && distGrid[x][y-2] != 0 && distGrid[x][y-2] - (distGrid[x][y]+2) >= 100) sum[0]++;
	if (y + 2 < LINES && distGrid[x][y+2] != 0 && distGrid[x][y+2] - (distGrid[x][y]+2) >= 100) sum[0]++;
    for (int i = -20; i <= 20; i++){
        for (int j = -20; j <= 20; j++){
            int dist = abs(x - x+i) + abs(y - y+j);
            int inGrid = (x+i >= 0 && x+i < LINES && y+j >= 0 && y+j < LINES) ? 1 : 0;
        	if(dist <= 20 && inGrid == 1 && distGrid[x+i][y+j] - (distGrid[x][y] + dist) >= 100 ) sum[1]++;
        }
    }
	if (distGrid[x-1][y] != 0 && distGrid[x-1][y] > distGrid[x][y]) countCheats(distGrid, x-1, y, sum);
	if (distGrid[x+1][y] != 0 && distGrid[x+1][y] > distGrid[x][y]) countCheats(distGrid, x+1, y, sum);
	if (distGrid[x][y-1] != 0 && distGrid[x][y-1] > distGrid[x][y]) countCheats(distGrid, x, y-1, sum);
	if (distGrid[x][y+1] != 0 && distGrid[x][y+1] > distGrid[x][y]) countCheats(distGrid, x, y+1, sum);
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input), distGrid[LINES][LINE_SIZE] = {0}, start[2] = {0}, sum[2] = {0};
    findStart(input, start);
    fillPath(input, distGrid, start[0], start[1], 1);
    countCheats(distGrid, start[0], start[1], sum);
    printf("Short Cheats: %d\nLong Cheats: %d\n", sum[0], sum[1]);
	return 0;
}
