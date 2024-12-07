#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LINE_SIZE 128
#define LINES 850

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen("./07input.txt", "r");
	int i = 0;
	if (input != NULL){
      while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void parseInput(char inputs[][LINE_SIZE], int lines, long data[][30], long target[]) {
    for (int i = 0; i < lines; i++) {
        target[i] = strtoul(strtok(inputs[i], ":"), NULL, 10);
        char *token = strtok(NULL, " ");
        int pos = 0;
        while (token != NULL) {
            data[i][pos++] = strtoul(token, NULL, 10);
            token = strtok(NULL, " ");
        }
        data[i][pos] = -1;
    }
}

long concat(long a, long b) {
    long offset = 1;
    while (b >= offset) {
        offset *= 10;
    }
    return a * offset + b;
}

int calc(long* data, int nums, long target, long curr, int part) {
    if (curr > target) return 0;
    if (nums == 0) {
        if (curr == target) return 1;
        return 0;
    }
    if (part == 1) {
        return calc(&data[1], nums - 1, target, curr + data[0], part) ||
           calc(&data[1], nums - 1, target, curr * data[0], part);
    } else {
        return calc(&data[1], nums - 1, target, curr + data[0], part) ||
           calc(&data[1], nums - 1, target, curr * data[0], part) ||
           calc(&data[1], nums - 1, target, concat(curr, data[0]), part);
    }
}

int main() {
  char input[LINES][LINE_SIZE];
	int lineCount = readInput(input);
  long data[lineCount][30], target[lineCount], sum[2] = {0};
	parseInput(input, lineCount, data, target);
    for (int i = 0; i < lineCount; i++) {
        int nums = 0;
        while (data[i][nums] != -1) nums++;
        int foundMatch = calc(&data[i][1], nums - 1, target[i], data[i][0], 1);
        if (foundMatch) {
        	  sum[0] += target[i];
            sum[1] += target[i];
        } else {
        	  foundMatch = calc(&data[i][1], nums - 1, target[i], data[i][0], 2);
            if (foundMatch) sum[1] += target[i];
        }
    }
    printf("%ld %ld\n", sum[0], sum[1]);
}
