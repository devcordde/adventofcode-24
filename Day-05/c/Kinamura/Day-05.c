#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LINE_SIZE 80
#define LINES 1400

int readInput(char prompts[][LINE_SIZE]) {
    FILE *input = fopen("./05input.txt", "r");
    int i = 0;
    if (input != NULL) {
        while (fgets(prompts[i++], LINE_SIZE, input) != NULL) {
        }
    }
    return (fclose(input) & 0) | (i - 1);
}

void parseInput(const int lines, char input[][LINE_SIZE], int rules[][2], int updates[][30], int *rulesC, int *updateC) {
    int part = 0, ruleCount = 0, updateCount = 0;
    for (int i = 0; i < lines; i++) {
        if (strlen(input[i]) == 1) { part = 1; continue; }
        if (!part) {
            char *firstPart = strtok(input[i], "|"), *secondPart = strtok(NULL, "\n");
            if (firstPart && secondPart) {
                rules[ruleCount][0] = atoi(firstPart);
                rules[ruleCount][1] = atoi(secondPart);
                ruleCount++;
            }
        } else {
            int column = 0;
            for (char *token = strtok(input[i], ","); token != NULL; token = strtok(NULL, ",")) {
                updates[updateCount][column++] = atoi(token);
            }
            updates[updateCount][column] = -1;
            updateCount++;
        }
    }
    *rulesC = ruleCount;
    *updateC = updateCount;
}

int getPos(const int number, const int update[]) {
    int pos = 0;
    while(1) {
        if (update[pos] == -1 && number != -1) return -1;
        if (update[pos] == number) return pos;
        pos++;
    }
}

int sort(const int rules[][2], int update[], const int rulesC) {
    int temp, swapped, alreadySorted = 1, n = getPos(-1, update);
    for (int i = 0; i < n - 1; i++) {
        swapped = 0;
        for (int j = 0; j < n - i - 1; j++) {
            int swap = 0;
            for (int k = 0; k < rulesC; k++) {
                if (rules[k][0] == update[j] && rules[k][1] == update[j + 1]) break;
                if (rules[k][1] == update[j] && rules[k][0] == update[j + 1]) { swap = 1; break; }
            }
            if (swap) {
            	  alreadySorted = 0;
                (update[j] ^= update[j + 1]), (update[j + 1] ^= update[j]), (update[j] ^= update[j + 1]);
                swapped = 1;
            }
        }
        if (swapped == 0) break;
    }
    return alreadySorted;
}

void checkUpdates(int update[][30], const int rules[][2], const int rulesC, const int updateC) {
    int sum1 = 0, sum2 = 0;
	  for (int i = 0; i < updateC; i++) {
        (sort(rules, update[i], rulesC)) ? (sum1 += update[i][getPos(-1, update[i]) / 2]) : (sum2 += update[i][getPos(-1, update[i]) / 2]);
	  }
    printf("Sorted: %d \nUnsorted: %d\n", sum1, sum2);
}

int main(int argc, char** argv) {
    char input[LINES][LINE_SIZE];
    int lineCount = readInput(input), ruleCount = 0, updateCount = 0;
    int rules[lineCount][2], updates[lineCount][30];
    parseInput(lineCount, input, rules, updates, &ruleCount, &updateCount);
    checkUpdates(updates, rules, ruleCount, updateCount);
    return 0;
}
