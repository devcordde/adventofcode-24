#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define LINE_SIZE 142
#define LINES 140

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen("./12input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

int isOob (int x, int y, int xDir, int yDir) {
	return !(x + xDir < 0 || x + xDir > LINES || y + yDir < 0 || y + yDir > LINES);
}

int * getRegionPrice(char input[][LINE_SIZE], int lines, int plots[][LINE_SIZE], int x, int y, int fieldCount) {
	int *result = (int *)calloc(sizeof(int), 2), dir[4][2] = { {1, 0}, {0, 1}, {-1, 0}, {0, -1} };
    if (x - 1 < 0 || input[x-1][y] != input[x][y]) result[1]++;
	if (x + 1 > lines || input[x+1][y] != input[x][y]) result[1]++;
	if (y - 1 < 0 || input[x][y-1] != input[x][y]) result[1]++;
	if (y + 1 > lines || input[x][y+1] != input[x][y]) result[1]++;
    plots[x][y] = fieldCount;
    result[0]++;
    for (int i = 0; i < 4; i++) {
    	if (isOob(x,y,dir[i][0], dir[i][1]) && input[x+dir[i][0]][y+dir[i][1]] == input[x][y] && plots[x+dir[i][0]][y+dir[i][1]] == 0) {
    		int *recRes = getRegionPrice(input, lines, plots, x + dir[i][0], y + dir[i][1], fieldCount);
    		result[0] += recRes[0];
    		result[1] += recRes[1];
    	}
    }
	return result;
}

int isValid(int plots[][LINE_SIZE], int lines, int x, int y, int xDir, int yDir) {
	return (!isOob(x ,y ,xDir ,yDir) || plots[x + xDir][y + yDir] != plots[x][y] );
}

int getNewFenceRules(int plots[][LINE_SIZE], int lines, int x, int y) {
    int sum = 0, co = 1, gap = 0, dir[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    for (int d = 0; d < 4; d++) {
		for (int i = 0; i < lines; i++) {
			for (int j = 0; j < lines; j++) {
				if ((d < 2 && co && plots[i][j] == plots[x][y] && isValid(plots, lines, i, j, dir[d][0], dir[d][1])) ||
            			d > 1 && co && plots[j][i] == plots[x][y] && isValid(plots, lines, j, i, dir[d][0], dir[d][1])) {
					sum++;
					co = 0;
				}
				if (d < 2 && co == 0 && (plots[i][j] != plots[x][y] || plots[i+dir[d][0]][j+dir[d][1]] == plots[x][y])) gap = 1;
				if (d > 1 && co == 0 && (plots[j][i] != plots[x][y] || plots[j+dir[d][0]][i+dir[d][1]] == plots[x][y])) gap = 1;
				if (co == 0 && gap == 1) {
					co = 1;
					gap = 0;
				}
			}
		}
    }
    return sum;
}

void buildFencingPrice(char input[][LINE_SIZE], int lines, int plots[][LINE_SIZE]) {
    int sum = 0, sum2 = 0, fieldCount = 1;
	for (int i = 0; i < lines; i++) {
        for (int j = 0; j < lines; j++) {
        	if (plots[i][j] == 0) {
                int * region = getRegionPrice(input, lines, plots,i,j, fieldCount++);
                sum += region[0] * region[1];
                sum2 += region[0] * getNewFenceRules(plots, lines, i, j);
        	}
        }
	}
    printf("Calculating method 1: %d\nCalculating method 2: %d\n", sum, sum2);
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int plots[LINES][LINE_SIZE] = {};
	int lineCount = readInput(input);
    buildFencingPrice(input, lineCount, plots);
	return 0;
}
