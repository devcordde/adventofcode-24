#include <stdio.h>
#include <string.h>

#define LINE_SIZE 128
#define LINES 64

int readInput(char prompts[][LINE_SIZE]){
    FILE *input = fopen("./10input.txt", "r");
    int i = 0;
    if (input != NULL){
        while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
    }
    return (fclose(input) & 0) | (i - 1);
}

int evalPaths2(char input[][LINE_SIZE], int lines, int x, int y) {
    if (x < 0 || x >= lines || y < 0 || y >= LINE_SIZE) return 0;
    if (input[x][y] == '9') return 1;
    int paths = 0;
    if (x > 0 && input[x-1][y] - input[x][y] == 1) paths += evalPaths2(input, lines, x - 1, y);
    if (x < lines - 1 && input[x+1][y] - input[x][y] == 1) paths += evalPaths2(input, lines, x + 1, y);
    if (y > 0 && input[x][y-1] - input[x][y] == 1) paths += evalPaths2(input, lines, x, y - 1);
    if (y < lines - 1 && input[x][y+1] - input[x][y] == 1) paths += evalPaths2(input, lines, x, y + 1);
    return paths;
}

void evalPaths(char input[][LINE_SIZE], int lines, int x, int y) {
    if (x < 0 || x >= lines || y < 0 || y >= LINE_SIZE) return;
    if (input[x][y] == '9') {
        input[x][y] = 'x';
        return;
    }
    if (x > 0 && input[x-1][y] - input[x][y] == 1) evalPaths(input, lines, x - 1, y);
    if (x < lines - 1 && input[x+1][y] - input[x][y] == 1) evalPaths(input, lines, x + 1, y);
    if (y > 0 && input[x][y-1] - input[x][y] == 1) evalPaths(input, lines, x, y - 1);
    if (y < lines - 1 && input[x][y+1] - input[x][y] == 1) evalPaths(input, lines, x, y + 1);
    return;
}

void parseInput(char input[][LINE_SIZE], int lines, int sum[]){
    for (int i = 0; i < lines; i++){
        for (int j = 0; j < LINE_SIZE; j++){
            if (input[i][j] == '0'){
                sum[1] += evalPaths2(input, lines, i, j);
                evalPaths(input, lines, i, j);
                int tSum = 0;
                for (int k = 0; k < lines; k++){
                    for (int l = 0; l < lines; l++){
                        if (input[k][l] == 'x'){
                            tSum++;
                            input[k][l] = '9';
                        }
                    }
                }
                sum[0] += tSum;
            }
        }
    }
}

int main(int argc, char** argv) {
    char input[LINES][LINE_SIZE];
    int lineCount = readInput(input);
    int sum[2] = {0, 0};
    parseInput(input, lineCount, sum);
    printf("%d %d\n", sum[0], sum[1]);
    return 0;
}
