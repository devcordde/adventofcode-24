#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#define LINE_SIZE 24
#define LINES 320

typedef struct wire{
	char name[4];
	int state;
} Wire;

typedef struct op{
	char wire[3][4], op[4];
	int eval;
} Op;

typedef struct {
    int inputA, inputB, op, state, type;
} Wires;

Wires wireTable[36*36*36] = {0};
char errors[8][4] = {0};
int wireCount = 0, opCount = 0, errorCount = 0, outputCount = 0;
int outputs[50], wireList[300];

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen("./24input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

int getNodeIndex(char *name, Wire wires[]) {
    for (int i = 0; i < wireCount; i++) {
        if (!strcmp(wires[i].name, name)) {
            return i;
        }
    }
    strcpy(wires[wireCount].name, name);
    wires[wireCount].state = -1;
    return wireCount++;
}

void parseInput(char input[][LINE_SIZE], int lines, Wire wires[], Op ops[]) {
	int part = 0, value;
	char currStr[4];
	for (int i = 0; i < lines; i++) {
		if (strlen(input[i]) == 1) {part = 1; continue;}
		if(part) {
			sscanf(input[i], "%s %s %s -> %s", ops[opCount].wire[0], ops[opCount].op, ops[opCount].wire[1], ops[opCount].wire[2]);
			getNodeIndex(ops[opCount].wire[0], wires);
			getNodeIndex(ops[opCount].wire[1], wires);
			getNodeIndex(ops[opCount].wire[2], wires);
			ops[opCount++].eval = 0;
		} else {
			sscanf(input[i], "%[^:]: %d", currStr, &value);
			currStr[3] = '\0';
			int idx = getNodeIndex(currStr, wires);
			wires[idx].state = value;
		}
	}
}

int evalAllZ(Wire wires[]) {
	for (int i = 0; i < wireCount; i++) {
		if (wires[i].name[0] == 'z' && wires[i].state == -1) return 0;
	}
	return 1;
}

int compareWires(const void *a, const void *b) {
    Wire *wa = (Wire *)a;
    Wire *wb = (Wire *)b;
    int numA = atoi(wa->name + 1);
    int numB = atoi(wb->name + 1);
    return numB - numA;
}

void buildDecimal(Wire wires[]) {
    Wire zWires[wireCount];
    int zCount = 0;
    for (int i = 0; i < wireCount; i++) {
        if (wires[i].name[0] == 'z') {
            zWires[zCount++] = wires[i];
        }
    }
    qsort(zWires, zCount, sizeof(Wire), compareWires);
	long sum = 0;
    for (int i = 0; i < zCount; i++) {
		sum = 2*sum + zWires[i].state;
    }
	printf("Decimal: %ld\n", sum);
}

void evaluateOps(Op ops[], Wire w[]) {
	while(!evalAllZ(w)) {
    for (int i = 0; i < opCount; i++) {
		if(ops[i].eval) continue;
        int i0 = getNodeIndex(ops[i].wire[0], w);
        int i1 = getNodeIndex(ops[i].wire[1], w);
        int i2 = getNodeIndex(ops[i].wire[2], w);
        if (w[i0].state != -1 && w[i1].state != -1) {
			if(!strcmp(ops[i].op,"AND")) w[i2].state = (w[i0].state == 1 && w[i1].state == 1) ? 1 : 0;
			if(!strcmp(ops[i].op,"OR")) w[i2].state = (w[i0].state == 1 || w[i1].state == 1) ? 1 : 0;
			if(!strcmp(ops[i].op,"XOR")) w[i2].state = (w[i0].state != w[i1].state) ? 1 : 0;
			ops[i].eval = 1;
        }
    }
	}
	buildDecimal(w);
}

int outputToIndex(char output[3]) {
    int result = 0;
    for (int i = 0; i < 3; i++) {
        result *= 36;
        if (output[i] >= 'a' && output[i] <= 'z') result += output[i] - 'a';
        if (output[i] >= '0' && output[i] <= '9') result += output[i] - '0' + 26;
    }
    return result;
}

void reparseInput(char input[LINES][LINE_SIZE], int lines, int l) {
	wireCount = 0;
	while(strlen(input[l++]) > 2) {
		char output[3];
        int state = 0;
        sscanf(input[l], "%3c: %d ", output, &state);
        int index = outputToIndex(output);
        wireTable[index] = (Wires){-1, -1, 3, state, 7};
	}
	l++;
    while (l < lines) {
        Wires w;
        char output[4], inputA[3], inputB[3], op[4];
        sscanf(input[l++], "%s %s %3c -> %3c ", inputA, op, inputB, output);
        if (op[0] == 'A') w.op = 0;
        else if (op[0] == 'O') w.op = 1;
        else if (op[0] == 'X') w.op = 2;
        int index = outputToIndex(output);
        w.inputA = outputToIndex(inputA);
        w.inputB = outputToIndex(inputB);
        w.state = -1;
        if (w.inputA == outputToIndex("x00") || w.inputB == outputToIndex("x00")) {
            if (w.op == 2) w.type = 0;
            else if (w.op == 0) w.type = 3;
        }
        else if (wireTable[w.inputA].type == 7) {
            if (w.op == 2)  w.type = 1;
            else if (w.op == 0)  w.type = 4;
        }
        else {
            if (w.op == 2) w.type = 2;
            else if (w.op == 0) w.type = 5;
            else if (w.op == 1) w.type = 6;
        }
        wireTable[index] = w;
        wireList[wireCount++] = index;
        if (output[0] == 'z') {
            int zIndex = atoi(&output[1]);
            outputCount = (outputCount > zIndex + 1 ) ? outputCount : zIndex + 1;
            outputs[zIndex] = index;
        }
    }
}

void indexToOutput(int index, char output[4]) {
    output[0] = index/(36*36);
    output[1] = (index/36)%36;
    output[2] = index%36;
	output[3] = '\0';
    for (int i = 0; i < 3; i++) {
        if (output[i] < 26) output[i] += 'a';
        else if (output[i] >= 26) {
            output[i] -= 26;
            output[i] += '0';
        }
    }
}

void addError(int index) {
    char output[4];
    indexToOutput(index, output);
	for (int i = 0; i < errorCount; i++) {
        if (!strncmp(output, errors[i], 3)) return;
    }
    strcpy(errors[errorCount++], output);
}

int comp(const void *a, const void *b) {
    return strcmp((char*)a, (char*)b);
}

void fixRippleCarry(char input[LINES][LINE_SIZE], int lines, int l) {
	reparseInput(input, lines, l);
    for (int i = 0; i < outputCount; i++) {
        Wires w = wireTable[outputs[i]];
        if (i == 0 && w.type == 0) continue;
        if (i == outputCount-1 && w.type == 6) continue;
        if (w.type == 2) continue;
        addError(outputs[i]);
    }
    for (int i = 0; i < wireCount; i++) {
        Wires w = wireTable[wireList[i]];
        Wires a = wireTable[w.inputA];
        Wires b = wireTable[w.inputB];
        if (w.type == 2 || w.type == 5) {
            if (a.type != 1 && a.type != 6 && a.type != 3) addError(w.inputA);
            if (b.type != 1 && b.type != 6 && b.type != 3) addError(w.inputB);
        }
        if (w.type == 6) {
            if (a.type != 4 && a.type != 5) addError(w.inputA);
            if (b.type != 4 && b.type != 5) addError(w.inputB);
        }
    }
    qsort(errors, errorCount, sizeof(char)*4, comp);
    for (int i = 0; i < errorCount; i++) {
        printf("%s", errors[i]);
        if (i != errorCount-1) {
            printf(",");
        }
    }
    printf("\n");
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input);
	Wire wires[LINES];
	Op ops[LINES];
	parseInput(input, lineCount, wires, ops);
	evaluateOps(ops, wires);
	fixRippleCarry(input, lineCount, 0);
	return 0;
}
