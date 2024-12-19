#include <stdio.h>
#include <string.h>

int readInput(char prompts[][3000]){
	FILE *input = fopen("./19input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],3000,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

int parseInput(char inputs[][3000], char exPats[][20], char desPats[][100]) {
	int i = 0, exPatCount = 0, desPatCount = 0;
	char *token = strtok(inputs[i++], ",");
	while (token != NULL) {
		char filteredToken[20] = {0};
		int k = 0;
		for (int j = 0; token[j] != '\0'; j++) {
			if (token[j] != ' ') {
				filteredToken[k++] = token[j];
			}
		}
		filteredToken[k] = '\0';
		strncpy(exPats[exPatCount], filteredToken, 20);
		exPats[exPatCount++][19] = '\0';
		token = strtok(NULL, ",");
	}
    exPats[exPatCount - 1][strlen(exPats[exPatCount - 1]) -1] = '\0';
	while (inputs[++i][0] != '\0') {
		strncpy(desPats[desPatCount], inputs[i], 99);
		desPats[desPatCount++][strlen(inputs[i]) -1] = '\0';
	}
    return exPatCount;
}

long checkPats(char* desPat, int currChar, long lut[100], char exPats[][20], int towelCount) {
	if (lut[currChar] != -1) return lut[currChar];
	long sum = 0;
	char* subDesPat = desPat + currChar;
	int sl = strlen(subDesPat);
	for (int i = 0; i < towelCount; i++) {
		int exPatLen = strlen(exPats[i]);
		if (exPatLen == sl && strcmp(subDesPat, exPats[i]) == 0) sum ++;
		if (exPatLen < sl && strncmp(subDesPat, exPats[i], exPatLen) == 0) {
			sum += checkPats(desPat, currChar + exPatLen, lut, exPats, towelCount);
		}
	}
	lut[currChar] = sum;
	return sum;
}

int main() {
	char input[500][3000] = {0}, exPats[500][20] = {0}, desPats[500][100] = {0};
	int lineCount = readInput(input), towelCount = parseInput(input, exPats, desPats), matchCount = 0;
	long sum = 0;
    for (int i = 0; i < 500 && desPats[i][0] != '\0'; i++) {
    	long lut[100];
    	for (int j = 0; j < 100; j++) {
    		lut[j] = -1;
    	}
    	long combinations = checkPats(desPats[i], 0, lut, exPats, towelCount);
    	if (combinations != 0) {
            sum += combinations;
            matchCount++;
        }
    }
	printf("Possible designs: %d\nPossible combinations: %ld\n", matchCount, sum);
	return 0;
}
