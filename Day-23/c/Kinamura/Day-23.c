#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define LINE_SIZE 8
#define LINES 3400

typedef struct {
    char name[3];
    int index;
} NodeMap;
NodeMap nodeMap[LINES];
int adj[LINES][LINES] = {0};
int nodeCount = 0;

int readInput(char prompt[][LINE_SIZE]){
	FILE *input = fopen("./23input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompt[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void parseInput(char input[][LINE_SIZE], char cons[][2][3], int lines) {
    for (int i = 0; i < lines; i++) {
        char* token = strtok(input[i], "-");
        strcpy(cons[i][0], token);
        token = strtok(NULL, "-");
        token[2] = '\0';
        strcpy(cons[i][1], token);
    }
}

int cmpNodeNames(const void *a, const void *b) {
    const char *nameA = (const char *)a;
    const char *nameB = (const char *)b;
    return strcmp(nameA, nameB);
}

int getNodeIndex(char *name) {
    for (int i = 0; i < nodeCount; i++) {
        if (!strcmp(nodeMap[i].name, name)) {
            return nodeMap[i].index;
        }
    }
    strcpy(nodeMap[nodeCount].name, name);
    nodeMap[nodeCount].index = nodeCount;
    return nodeCount++;
}

int countTriangles(int nodes) {
    int triangleCount = 0;
    for (int u = 0; u < nodes; u++) {
        for (int v = u + 1; v < nodes; v++) {
            if (adj[u][v]) {
                for (int w = v + 1; w < nodes; w++) {
                    if (adj[u][w] && adj[v][w]) {
                        if (nodeMap[u].name[0] == 't' || nodeMap[v].name[0] == 't' || nodeMap[w].name[0] == 't') {
                            triangleCount++;
                        }
                    }
                }
            }
        }
    }
    return triangleCount;
}

int findLargestGroup(int nodes, int *group) {
    int maxGroupSize = 0;
    int currGroup[LINES];
    int currSize;
    for (int start = 0; start < nodes; start++) {
        currSize = 0;
        currGroup[currSize++] = start;
        for (int neighbor = 0; neighbor < nodes; neighbor++) {
            if (neighbor == start) continue;
            int isConnected = 1;
            for (int i = 0; i < currSize; i++) {
                if (!adj[currGroup[i]][neighbor]) {
                    isConnected = 0;
                    break;
                }
            }
            if (isConnected) currGroup[currSize++] = neighbor;
        }
        if (currSize > maxGroupSize) {
            maxGroupSize = currSize;
            memcpy(group, currGroup, maxGroupSize * sizeof(int));
        }
    }
    return maxGroupSize;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input), group[LINES];
    char cons[lineCount][2][3];
    parseInput(input, cons, lineCount); 
    for (int i = 0; i < lineCount; i++) {
        int u = getNodeIndex(cons[i][0]);
        int v = getNodeIndex(cons[i][1]);
        adj[u][v] = adj[v][u] = 1;
    }
    printf("Groups of 3: %d\n", countTriangles(nodeCount));
    int groupSize = findLargestGroup(nodeCount, group);
    char sortedGroup[groupSize][3];
    for (int i = 0; i < groupSize; i++) {
        strcpy(sortedGroup[i], nodeMap[group[i]].name);
    }
    qsort(sortedGroup, groupSize, sizeof(sortedGroup[0]), cmpNodeNames);
    printf("Password: ");
    for (int i = 0; i < groupSize; i++) {
        printf("%s", sortedGroup[i]);
        if (i < groupSize - 1) printf(","); else printf("\n");
    }
	return 0;
}
