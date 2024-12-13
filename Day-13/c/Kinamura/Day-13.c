#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define LINE_SIZE 128
#define LINES 1280

typedef struct game {
	int a[2], b[2];
    long tar[2];
} Game;

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen("./13input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void parseInput(char input[][LINE_SIZE], int lines, Game *games, int *gameCount) {
	int i = 0;
	int currGame = 0;
	while (i < lines) {
		if (strlen(input[i]) == 1) {
			currGame++;
            i++;
			continue;
		}
		sscanf(input[i++], "Button A: X+%d, Y+%d", &games[currGame].a[0], &games[currGame].a[1]);
		sscanf(input[i++], "Button B: X+%d, Y+%d", &games[currGame].b[0], &games[currGame].b[1]);
		sscanf(input[i++], "Prize: X=%ld, Y=%ld", &games[currGame].tar[0], &games[currGame].tar[1]);
	}
	*gameCount = currGame + 1;
}

long getCost(Game g, int part) {
    if (part) {
    	g.tar[0] += 10000000000000;
    	g.tar[1] += 10000000000000;
    }
	long det = g.a[0] * g.b[1] - g.a[1] * g.b[0];
	if (det == 0) return 0;
	long n1 = (g.tar[0] * g.b[1] - g.tar[1] * g.b[0]);
	long n2 = (g.tar[1] * g.a[0] - g.tar[0] * g.a[1]);
	if (n1 % det != 0 || n2 % det != 0) return 0;
	long cost = 3 * (n1 / det) + (n2 / det);
    return cost;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input), gameCount = 0;
    Game games[lineCount/3];
    parseInput(input, lineCount, games, &gameCount);
    long sum = 0, sum2 = 0;
    for (int i = 0; i < gameCount; i++) {
    	sum += getCost(games[i], 0);
        sum2 += getCost(games[i], 1);
    }
    printf("Minimum cost Part 1: %ld\nMinimum cost Part 2: %ld\n", sum, sum2);
	return 0;
}
