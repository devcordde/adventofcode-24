#include <stdio.h>
#include <string.h>

int readInput(long secrets[]) {
    FILE *input = fopen("./22input.txt", "r");
    int i = 0;
    if (input != NULL) {
        while (fscanf(input, "%ld", &secrets[i++]) == 1) {}
    }
    return (fclose(input) & 0) | (i - 1);
}

int getSeqPos(int* seq) {
	return (seq[0]+9)*19*19*19 + (seq[1]+9)*19*19 + (seq[2]+9)*19 + seq[3]+9;
}

int itSecret(long secret) {
    secret = ((secret << 6) ^ secret) % (1 << 24);
    secret = ((secret >> 5) ^ secret) % (1 << 24);
    secret = ((secret << 11) ^ secret) % (1 << 24);
    return secret;
}

int traverseSecrets(long secrets[], int lines) {
    int seqSum[19*19*19*19] = {0}, cost = 0;
    for (int i = 0; i < lines; i++) {
        int visited[19*19*19*19] = {0};
        int prev = 0, price[2000], diff[2000];
        for (int j = 0; j < 2000; j++) {
            secrets[i] = itSecret(secrets[i]);
            price[j] = (secrets[i] % 10);
            diff[j] = (secrets[i] % 10) - prev;
            prev = price[j];
        }
        for (int j = 1; j+3 < 2000; j++) {
            int seqPos = getSeqPos(&diff[j]);
            if (!visited[seqPos]) {
                visited[seqPos] = 1;
                seqSum[seqPos] += price[j+3];
            }
        }
    }
    for (int i = 0; i < 19*19*19*19; i++) {
        cost = (cost < seqSum[i]) ?  seqSum[i] : cost;
    }
    return cost;
}

int main(int argc, char** argv) {
    long secrets[2000], sum = 0;
    int lineCount = readInput(secrets);
    int cost = traverseSecrets(secrets, lineCount);
    for (int i = 0; i < lineCount; i++) sum += secrets[i];
    printf("Secret Sum: %ld\nMax Bananas: %d\n", sum, cost);
	return 0;
}
