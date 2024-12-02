#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define LINE_SIZE 128
#define LINES 1001

int readInput(char prompts[][LINE_SIZE]){
    FILE *input = fopen("./02input.txt", "r");
    int i = 0;
    if (input != NULL){
        while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
    }
    return (fclose(input) & 0) | (i - 1);
}

void parseInput(const int lines, char input[][LINE_SIZE], int output[][10]) {
    for (int i = 0; i < lines; i++) {
        char *token = strtok(input[i], " ");
        int column = 0;
        while (token != NULL && column < 10) {
            output[i][column++] = atoi(token);
            token = strtok(NULL, " ");
        }
        for (int j = column; j < 10; j++) {
            output[i][j] = -1;
        }
    }
}

void removeElement(const int arr[], const int index, int newArr[]) {
    int oldIndex = 0;
    for (int i = 0; i < 9; i++) {
        if (i == index) oldIndex++;
        newArr[i] = arr[oldIndex++];
    }
    newArr[9] = -1;
}

int checkReports(const int output[10], const int isDoubleCheck) {
    if (output[0] == output[1]) {
        if (isDoubleCheck) return 0;
        int newArr[12];
        removeElement(output, 0, newArr);
        return checkReports(newArr, 1);
    }
    const int direction = (output[1] - output[0] > 0) ? 1 : -1;
    for (int i = 1; i < 10; i++) {
        if (output[i] == -1 || output[i - 1] == -1) return 1;
        const int diff = output[i] - output[i - 1];
        if (direction * diff < 0 || abs(diff) > 3 || abs(diff) == 0) {
            if (isDoubleCheck) return 0;
            for (int j = 0; j < 10; j++) {
                int newArr[10];
                removeElement(output, j, newArr);
                if (checkReports(newArr, 1)) return 1;
            }
            return 0;
        }
    }
    return 1;
}

int main(int argc, char *argv[]) {
    char input[LINES][LINE_SIZE];
    const int lineCount = readInput(input);
    int reports[lineCount][10], safeLevels[2];
    parseInput(lineCount, input, reports);
    for (int i = 0; i < lineCount; i++) {
        safeLevels[0] += checkReports(reports[i], 1);
        safeLevels[1] += checkReports(reports[i], 0);
    }
    printf("Safe cases: %d\n", safeLevels[0]);
    printf("Safe cases: %d\n", safeLevels[1]);
    return 0;
}
