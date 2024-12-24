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

int wireCount = 0, opCount = 0;

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

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input);
	Wire wires[LINES];
	Op ops[LINES];
	parseInput(input, lineCount, wires, ops);
	evaluateOps(ops, wires);
	return 0;
}
