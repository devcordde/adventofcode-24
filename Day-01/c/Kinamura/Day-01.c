#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define LINE_SIZE 128
#define LINES 1001

int readInput(char prompts[][LINE_SIZE]){
    FILE *input = fopen("./01input.txt", "r");
    int i = 0;
    if (input != NULL){
        while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
    }
    return (fclose(input) & 0) | (i - 1);
}

void parseInput(const int lines, char input[][LINE_SIZE], int fst[], int snd[]) {
    for (int i = 0; i < lines; i++) {
        fst[i] = atoi(strtok(input[i], " "));
        snd[i] = atoi(strtok(NULL, " "));
    }
}

int compare(const void *a, const void *b) {
    const int int_a = *(int *)a;
    const int int_b = *(int *)b;
    return int_a - int_b;
}

void sumDifferences(int fst[], int snd[], const int lines) {
    int diffs = 0;
    for (int i = 0; i < lines; i++) {
        diffs += abs(fst[i] - snd[i]);
    }
    fprintf(stdout, "%d\n", diffs);
}

void similarity(const int fst[], const int snd[], const int lines) {
    int score = 0;
    for (int i = 0; i < lines; i++) {
        int count = 0;
        for (int j = 0; j < lines; j++) {
            if (fst[i] == snd[j]) count++;
        }
        score += fst[i] * count;
    }
    fprintf(stdout, "%d\n", score);
}

int main(int argc, char *argv[]) {
    char input[LINES][LINE_SIZE];
    const int lineCount = readInput(input);
    int fst[lineCount], snd[lineCount];
    parseInput(lineCount, input, fst, snd);
    qsort(fst, lineCount, sizeof(int), &compare);
    qsort(snd, lineCount, sizeof(int), &compare);
    sumDifferences(fst, snd, lineCount);
    similarity(fst, snd, lineCount);
    return 0;
}
