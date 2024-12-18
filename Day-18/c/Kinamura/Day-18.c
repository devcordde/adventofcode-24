#include <stdio.h>
#include <string.h>

#define LINES 3450

int readInput(char prompts[][32]){
	FILE *input = fopen("./18input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],32,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void parseInput(char input[][32], char grid[71][71]) {
    int x = 0 ,y = 0;
	for (int i = 0; i < 1024; i++) {
		sscanf(input[i], "%d,%d", &y, &x);
        grid[x][y] = '#';
    }
}

void findPath(char grid[71][71], int costmap[71][71], int x, int y, int cost) {
	if(x < 0 || x >= 71 || y < 0 || y >= 71) return;
    if(costmap[x][y] <= cost || grid[x][y] == '#') return;
    costmap[x][y] = cost;
    findPath(grid,costmap,x+1,y,cost + 1);
	findPath(grid,costmap,x-1,y,cost + 1);
	findPath(grid,costmap,x,y+1,cost + 1);
	findPath(grid,costmap,x,y-1,cost + 1);
}

void initCostmap(int costmap[71][71]) {
	for (int a = 0; a < 71; a++) {
		for (int b = 0; b < 71; b++) {
			costmap[a][b] = 99999999;
		}
	}
}

void findBlockCoords(char grid[71][71], char input[][32]) {
    int i = 1024;
	while (1) {
		int x = 0 ,y = 0, costmap[71][71];
		sscanf(input[i++], "%d,%d", &y, &x);
		grid[x][y] = '#';
        initCostmap(costmap);
		costmap[0][0] = 1;
		findPath(grid, costmap, 0, 0, 0);
        if (costmap[71-1][71-1] == 99999999) {
        	printf("First blocking byte: (%d,%d)\n", y,x);
            return;
        }
    }
}

int main(int argc, char** argv) {
	char input[LINES][32], grid[71][71];
    int costmap[71][71], lineCount = readInput(input);;
    initCostmap(costmap);
    parseInput(input, grid);
    costmap[0][0] = 1;
    findPath(grid, costmap, 0, 0, 0);
    printf("Minimum steps: %d\n", costmap[71-1][71-1]);
    findBlockCoords(grid, input);
	return 0;
}
