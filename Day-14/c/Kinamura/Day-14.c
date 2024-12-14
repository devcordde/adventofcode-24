#include <stdio.h>
#include <string.h>

#define LINE_SIZE 128
#define LINES 512
#define GRID_X 103
#define GRID_Y 101

typedef struct bot {
    int pos[2],vel[2];
} Bot;

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen("./14input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void parseInput(char input[LINES][LINE_SIZE], int lines, Bot bots[]) {
	for (int i = 0; i < lines; i++) {
		sscanf(input[i], "p=%d,%d v=%d,%d\n", &bots[i].pos[1], &bots[i].pos[0], &bots[i].vel[1], &bots[i].vel[0]);
	}
}

int getSafetyLevel(int lines, Bot bots[]) {
	int counts[4] = {0};
	for (int i = 0; i < lines; i++) {
		if (bots[i].pos[0] < GRID_X/2 && bots[i].pos[1] < GRID_Y/2) counts[0]++;
		if (bots[i].pos[0] < GRID_X/2 && bots[i].pos[1] > GRID_Y/2) counts[1]++;
		if (bots[i].pos[0] > GRID_X/2 && bots[i].pos[1] < GRID_Y/2) counts[2]++;
		if (bots[i].pos[0] > GRID_X/2 && bots[i].pos[1] > GRID_Y/2) counts[3]++;
	}
	return counts[0] * counts[1] * counts[2] * counts[3];
}

void doCycle(int lines, Bot bots[]) {
	for (int i = 0; i < lines; i++) {
		bots[i].pos[0] = (bots[i].pos[0] + bots[i].vel[0]) % GRID_X;
		if (bots[i].pos[0] < 0) bots[i].pos[0] = GRID_X + bots[i].pos[0];
		bots[i].pos[1] = (bots[i].pos[1] + bots[i].vel[1]) % GRID_Y;
		if (bots[i].pos[1] < 0) bots[i].pos[1] = GRID_Y + bots[i].pos[1];
	}
}

int getMinSafetyLevel(int levels[]) { 
	int minValue = 2000000000, time = 0;
	for (int i = 0; i < 10500; i++) {
		if (levels[i] < minValue) {
			minValue = levels[i];
			time = i;
		}
	}
	return time;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input);
	Bot bots[lineCount];
	parseInput(input, lineCount, bots);
	int safetyLevels[10500];
	for (int i = 0; i < 10500; i++) {
		doCycle(lineCount, bots);
		safetyLevels[i] = getSafetyLevel(lineCount, bots);
	}
	printf("Security Level: %d\n", safetyLevels[99]);
	printf("Easter Egg time: %d\n", getMinSafetyLevel(safetyLevels) + 1);
	return 0;
} 
