#include <stdio.h>
#include <string.h>

#define LINE_SIZE 7
#define LINES 4000

int keyC = 0, lockC = 0;

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen("./25input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void parseInput(char input[][LINE_SIZE], int lines, int key[][5], int lock[][5]) {
    int currGrid[5] = {0}, firstLine = 1, firstLineC = 0;
    for(int i = 0; i < lines; i++) {
        if(strlen(input[i]) > 1) {
            if(firstLine) {
                firstLine = 0;
                if(input[i][0] == '.') firstLineC = 0; else firstLineC = 1;
            }
            for(int j = 0; j < 5; j++) {
                currGrid[j] += (input[i][j] == '.') ? 0 : 1;
            }
        }
        if(strlen(input[i]) < 2) {
            for(int j = 0; j < 5; j++) {
                if(firstLineC) {
                    key[keyC][j] = currGrid[j];
                } else {
                    lock[lockC][j] = currGrid[j];
                }
                currGrid[j] = 0;
            }
            if(!firstLineC) lockC++; else keyC++;
            firstLine = 1;
            firstLineC = 0;
        }
    }
    for(int j = 0; j < 5; j++) {
        if(firstLineC) {
            key[keyC][j] = currGrid[j];
        } else {
            lock[lockC][j] = currGrid[j];
        }
        currGrid[j] = 0;
    }
    if(firstLineC == 0) lockC++; else keyC++;
}

int tryPair(int key[], int lock[]) {
    for (int i = 0; i < 5; i++) {
        if(key[i] + lock[i] > 7) return 0; 
    }
    return 1;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
    int key[LINES/3][5], lock[LINES/3][5];
	int lineCount = readInput(input);
    parseInput(input, lineCount, key, lock);
    int count = 0;
    for(int i = 0; i < keyC; i++) {
        for(int j = 0; j < lockC; j++) {
            if(tryPair(key[i], lock[j])) count++;
        }
    }
    printf("Count: %d\n", count);
	return 0;
}
