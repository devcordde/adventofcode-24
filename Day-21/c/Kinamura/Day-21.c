#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <string.h>

#define LINE_SIZE 10
#define LINES 6
#define MAP_SIZE 20000

typedef struct {
	char* inputStr;
	int currIt;
} Key;
unsigned long long* cache[MAP_SIZE];

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen("./21input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

unsigned int hash(Key key) {
	unsigned int hashValue = 0;
	for (int i = 0; key.inputStr[i] != '\0'; i++) {
		hashValue = (hashValue * 31) + key.inputStr[i];
	}
	return (hashValue + key.currIt) % MAP_SIZE;
}

unsigned long long* findMem(Key key) {
	return cache[hash(key)];
}

void insertMem(Key key, unsigned long long value) {
	unsigned int bucket = hash(key);
	cache[bucket] = (unsigned long long*)malloc(sizeof(unsigned long long));
	*(cache[bucket]) = value;
}

void clearMemCache() {
	for (int i = 0; i < MAP_SIZE; i++) {
		if (cache[i] != NULL) {
			free(cache[i]);
			cache[i] = NULL;
		}
	}
}

char * lut(char prev, char curr) {
    char* result = (char *)malloc(7 * sizeof(char));
    if (prev == curr) strcpy(result, "A");
  	else if (prev == 'A' && curr == 'v') strcpy(result,"<vA");
	else if (prev == 'A' && curr == '<') strcpy(result,"v<<A");
	else if (prev == 'A' && curr == '>') strcpy(result,"vA");
	else if (prev == 'A' && curr == '^') strcpy(result,"<A");
	else if (prev == 'v' && curr == '<') strcpy(result,"<A");
	else if (prev == 'v' && curr == '>') strcpy(result,">A");
	else if (prev == 'v' && curr == 'A') strcpy(result,"^>A");
	else if (prev == '<' && curr == '^') strcpy(result,">^A");
	else if (prev == '<' && curr == 'v') strcpy(result,">A");
	else if (prev == '<' && curr == 'A') strcpy(result,">>^A");
	else if (prev == '>' && curr == 'v') strcpy(result,"<A");
	else if (prev == '>' && curr == '^') strcpy(result,"<^A");
	else if (prev == '>' && curr == 'A') strcpy(result,"^A");
	else if (prev == '^' && curr == '>') strcpy(result,"v>A");
	else if (prev == '^' && curr == '<') strcpy(result,"v<A");
	else if (prev == '^' && curr == 'A') strcpy(result,">A");
	else if (prev == 'A' && curr == '0') strcpy(result,"<A");
	else if (prev == 'A' && curr == '1') strcpy(result,"^<<A");
	else if (prev == 'A' && curr == '2') strcpy(result,"<^A");
	else if (prev == 'A' && curr == '3') strcpy(result,"^A");
	else if (prev == 'A' && curr == '4') strcpy(result,"^^<<A");
	else if (prev == 'A' && curr == '5') strcpy(result,"<^^A");
	else if (prev == 'A' && curr == '6') strcpy(result,"^^A");
	else if (prev == 'A' && curr == '7') strcpy(result,"^^^<<A");
	else if (prev == 'A' && curr == '8') strcpy(result,"<^^^A");
	else if (prev == 'A' && curr == '9') strcpy(result,"^^^A");
	else if (prev == '0' && curr == 'A') strcpy(result,">A");
	else if (prev == '0' && curr == '1') strcpy(result,"^<A");
	else if (prev == '0' && curr == '2') strcpy(result,"^A");
	else if (prev == '0' && curr == '3') strcpy(result,"^>A");
	else if (prev == '0' && curr == '4') strcpy(result,"^^<A");
	else if (prev == '0' && curr == '5') strcpy(result,"^^A");
	else if (prev == '0' && curr == '6') strcpy(result,"^^>A");
	else if (prev == '0' && curr == '7') strcpy(result,"^^^<A");
	else if (prev == '0' && curr == '8') strcpy(result,"^^^A");
	else if (prev == '0' && curr == '9') strcpy(result,"^^^>A");
	else if (prev == '1' && curr == 'A') strcpy(result,">>vA");
	else if (prev == '1' && curr == '0') strcpy(result,">vA");
	else if (prev == '1' && curr == '2') strcpy(result,">A");
	else if (prev == '1' && curr == '3') strcpy(result,">>A");
	else if (prev == '1' && curr == '4') strcpy(result,"^A");
	else if (prev == '1' && curr == '5') strcpy(result,"^>A");
	else if (prev == '1' && curr == '6') strcpy(result,"^>>A");
	else if (prev == '1' && curr == '7') strcpy(result,"^^A");
	else if (prev == '1' && curr == '8') strcpy(result,"^^>A");
	else if (prev == '1' && curr == '9') strcpy(result,"^^>>A");
	else if (prev == '2' && curr == 'A') strcpy(result,"v>A");
	else if (prev == '2' && curr == '0') strcpy(result,"vA");
	else if (prev == '2' && curr == '1') strcpy(result,"<A");
	else if (prev == '2' && curr == '3') strcpy(result,">A");
	else if (prev == '2' && curr == '4') strcpy(result,"<^A");
	else if (prev == '2' && curr == '5') strcpy(result,"^A");
	else if (prev == '2' && curr == '6') strcpy(result,"^>A");
	else if (prev == '2' && curr == '7') strcpy(result,"<^^A");
	else if (prev == '2' && curr == '8') strcpy(result,"^^A");
	else if (prev == '2' && curr == '9') strcpy(result,"^^>A");
	else if (prev == '3' && curr == 'A') strcpy(result,"vA");
	else if (prev == '3' && curr == '0') strcpy(result,"<vA");
	else if (prev == '3' && curr == '1') strcpy(result,"<<A");
	else if (prev == '3' && curr == '2') strcpy(result,"<A");
	else if (prev == '3' && curr == '4') strcpy(result,"<<^A");
	else if (prev == '3' && curr == '5') strcpy(result,"<^A");
	else if (prev == '3' && curr == '6') strcpy(result,"^A");
	else if (prev == '3' && curr == '7') strcpy(result,"<<^^A");
	else if (prev == '3' && curr == '8') strcpy(result,"<^^A");
	else if (prev == '3' && curr == '9') strcpy(result,"^^A");
	else if (prev == '4' && curr == 'A') strcpy(result,">>vvA");
	else if (prev == '4' && curr == '0') strcpy(result,">vvA");
	else if (prev == '4' && curr == '1') strcpy(result,"vA");
	else if (prev == '4' && curr == '2') strcpy(result,"v>A");
	else if (prev == '4' && curr == '3') strcpy(result,"v>>A");
	else if (prev == '4' && curr == '5') strcpy(result,">A");
	else if (prev == '4' && curr == '6') strcpy(result,">>A");
	else if (prev == '4' && curr == '7') strcpy(result,"^A");
	else if (prev == '4' && curr == '8') strcpy(result,"^>A");
	else if (prev == '4' && curr == '9') strcpy(result,"^>>A");
	else if (prev == '5' && curr == 'A') strcpy(result,"vv>A");
	else if (prev == '5' && curr == '0') strcpy(result,"vvA");
	else if (prev == '5' && curr == '1') strcpy(result,"<vA");
	else if (prev == '5' && curr == '2') strcpy(result,"vA");
	else if (prev == '5' && curr == '3') strcpy(result,"v>A");
	else if (prev == '5' && curr == '4') strcpy(result,"<A");
	else if (prev == '5' && curr == '6') strcpy(result,">A");
	else if (prev == '5' && curr == '7') strcpy(result,"<^A");
	else if (prev == '5' && curr == '8') strcpy(result,"^A");
	else if (prev == '5' && curr == '9') strcpy(result,"^>A");
	else if (prev == '6' && curr == 'A') strcpy(result,"vvA");
	else if (prev == '6' && curr == '0') strcpy(result,"<vvA");
	else if (prev == '6' && curr == '1') strcpy(result,"<<vA");
	else if (prev == '6' && curr == '2') strcpy(result,"<vA");
	else if (prev == '6' && curr == '3') strcpy(result,"vA");
	else if (prev == '6' && curr == '4') strcpy(result,"<<A");
	else if (prev == '6' && curr == '5') strcpy(result,"<A");
	else if (prev == '6' && curr == '7') strcpy(result,"<<^A");
	else if (prev == '6' && curr == '8') strcpy(result,"<^A");
	else if (prev == '6' && curr == '9') strcpy(result,"^A");
	else if (prev == '7' && curr == 'A') strcpy(result,">>vvvA");
	else if (prev == '7' && curr == '0') strcpy(result,">vvvA");
	else if (prev == '7' && curr == '1') strcpy(result,"vvA");
	else if (prev == '7' && curr == '2') strcpy(result,"vv>A");
	else if (prev == '7' && curr == '3') strcpy(result,"vv>>A");
	else if (prev == '7' && curr == '4') strcpy(result,"vA");
	else if (prev == '7' && curr == '5') strcpy(result,"v>A");
	else if (prev == '7' && curr == '6') strcpy(result,"v>>A");
	else if (prev == '7' && curr == '8') strcpy(result,">A");
	else if (prev == '7' && curr == '9') strcpy(result,">>A");
	else if (prev == '8' && curr == 'A') strcpy(result,"vvv>A");
	else if (prev == '8' && curr == '0') strcpy(result,"vvvA");
	else if (prev == '8' && curr == '1') strcpy(result,"<vvA");
	else if (prev == '8' && curr == '2') strcpy(result,"vvA");
	else if (prev == '8' && curr == '3') strcpy(result,"vv>A");
	else if (prev == '8' && curr == '4') strcpy(result,"<vA");
	else if (prev == '8' && curr == '5') strcpy(result,"vA");
	else if (prev == '8' && curr == '6') strcpy(result,"v>A");
	else if (prev == '8' && curr == '7') strcpy(result,"<A");
	else if (prev == '8' && curr == '9') strcpy(result,">A");
	else if (prev == '9' && curr == 'A') strcpy(result,"vvvA");
	else if (prev == '9' && curr == '0') strcpy(result,"<vvvA");
	else if (prev == '9' && curr == '1') strcpy(result,"<<vvA");
	else if (prev == '9' && curr == '2') strcpy(result,"<vvA");
	else if (prev == '9' && curr == '3') strcpy(result,"vvA");
	else if (prev == '9' && curr == '4') strcpy(result,"<<vA");
	else if (prev == '9' && curr == '5') strcpy(result,"<vA");
	else if (prev == '9' && curr == '6') strcpy(result,"vA");
	else if (prev == '9' && curr == '7') strcpy(result,"<<A");
	else if (prev == '9' && curr == '8') strcpy(result,"<A");
	return result;
}

long long replaceString(char* inputStr, int currIt, int maxIt) {
	Key key = {inputStr, currIt};
	unsigned long long* cachedResult = findMem(key), length = 0;
	if (cachedResult != NULL) return *cachedResult;
	int len = strlen(inputStr);
	char previousChar = 'A';
	for (int i = 0; i < len; i++) {
		if (currIt == maxIt - 1) length += strlen(lut(previousChar, inputStr[i]));
		else length += replaceString(lut(previousChar, inputStr[i]), currIt + 1, maxIt);
		previousChar = inputStr[i];
	}
	insertMem(key, length);
	return length;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input);
	unsigned long long sum = 0;
    for (int i = 0; i < lineCount; ++i) {
        unsigned long long length = replaceString(input[i], 0, 3);
    	int number = strtol(input[i], NULL, 10);
        sum += number * length;
    }
    printf("Part 1: %lld\n", sum);
    clearMemCache();
    sum = 0;
	for (int i = 0; i < lineCount; ++i) {
		unsigned long long length = replaceString(input[i], 0, 26);
		int number = strtol(input[i], NULL, 10);
		sum += number * length;
	}
	printf("Part 2: %lld\n", sum);
	return 0;
}
