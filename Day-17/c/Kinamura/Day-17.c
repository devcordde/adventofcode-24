#include <stdio.h>
#include <string.h>
#include <math.h>
#include <limits.h>

#define LINE_SIZE 128

typedef struct alu {
    long regA, regB, regC, op[16], ops;
    char opStr[64];
} Alu;
long ml = LONG_MAX;

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen("./17input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

Alu parseInput(char input[][LINE_SIZE]) {
	Alu alu = {0,0,0,{0}, 0, ""};
	sscanf(input[0], "Register A: %ld", &alu.regA);
    const char *ptr = input[4];
    int i = 0;
    char * progStart = strchr(input[4], ' ') + 1;
    strcpy(alu.opStr, progStart);
	while (sscanf(ptr, "%*[^0-9]%ld", &alu.op[i]) == 1) {
		ptr = strchr(ptr, alu.op[i++] + '0');
		if (ptr) ptr++;
	}
    alu.ops = i - 1;
    return alu;
}

char * runInstr(Alu alu, char prog[64]) {
    int opPos = 0, progPos = 0;
    while (1) {
        if (opPos >= alu.ops) { prog[progPos++] = '\0'; return prog; }
        long cOp = -1;
        if (alu.op[opPos + 1] < 4) cOp = alu.op[opPos + 1];
        if (alu.op[opPos + 1] == 4) cOp = alu.regA;
        if (alu.op[opPos + 1] == 5) cOp = alu.regB;
        if (alu.op[opPos + 1] == 6) cOp = alu.regC;
        switch (alu.op[opPos]) {
            case 0: alu.regA = alu.regA / pow(2, cOp); opPos += 2; break;
            case 1: alu.regB = alu.regB ^ alu.op[opPos + 1]; opPos += 2; break;
            case 2: alu.regB = cOp % 8; opPos += 2; break;
            case 3: opPos = (alu.regA == 0) ? opPos + 2 : alu.op[opPos + 1]; break;
            case 4: alu.regB = alu.regB ^ alu.regC; opPos += 2; break;
            case 5: {
                if (progPos != 0) prog[progPos++] = ',';
                prog[progPos++] = '0' + (cOp % 8);
                opPos += 2;
                break;
            }
            case 6: alu.regB = alu.regA / pow(2, cOp); opPos += 2; break;
            case 7: alu.regC = alu.regA / pow(2, cOp); opPos += 2; break;
        }
    }
}

void minReg(Alu alu, int it, long regA) {
    if (it > alu.ops) return;
    long baseReg = 8 * regA;
    char prog[64];
    for (int i = 0; i < 8; i++) {
        alu.regA = baseReg + i;
        runInstr(alu, prog);
        int isValid = !strcmp(prog, &alu.opStr[strlen(alu.opStr) - strlen(prog)]);
        if (isValid && it == alu.ops && ml > baseReg + i) { ml = baseReg + i; return; }
        if (isValid) minReg(alu, it + 1, baseReg + i);
        if (it > alu.ops + 1) return;
    }
}

int main(int argc, char** argv) {
	char input[5][LINE_SIZE], prog[64];
	readInput(input);
    Alu instr = parseInput(input);
    runInstr(instr, prog);
    minReg(instr, 0, 0);
    printf("Output: %s\nLowest initial Register A:%ld\n", prog, ml);
	return 0;
}
