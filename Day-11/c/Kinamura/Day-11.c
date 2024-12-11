#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct node;
typedef struct node {
	long value;
    long occurrences;
	struct node* next;
} Node;

int readInput(char prompts[][40]){
	FILE *input = fopen("./11input.txt", "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],40,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

Node* parseInput(char* line) {
	Node* head = NULL;
	Node* current = NULL;
	const char* pos = line;
	while (*pos) {
		if (*pos == '\0') break;
		char* end;
		long value = strtol(pos, &end, 10);
		if (pos == end) break;
		Node* newNode = (Node*)malloc(sizeof(Node));
		newNode->value = value;
        newNode->occurrences = 1;
		newNode->next = NULL;
		if (!head) {
			head = newNode;
		} else {
		current->next = newNode;
		}
		current = newNode;
		pos = end;
	}
	return head;
}

int getDigits(Node* head) {
	int count = 0;
	long value = head->value;
	while (value > 0) {
		count++;
		value /= 10;
	}
	return count > 0 ? count : 1;
}

void doLoop(Node * head) {
	while (head != NULL) {
    	if (head->value == 0) {
        	head->value = 1;
            head = head->next;
            continue;
        }
        int digits = getDigits(head);
		if (digits % 2 == 0) {
			long value = head->value;
			long divisor = 1;
			for (int i = 0; i < digits / 2; i++) {
				divisor *= 10;
			}
			Node* newNode = (Node*)malloc(sizeof(Node));
			newNode->value = value % divisor;
			head->value = value / divisor;
        	newNode->occurrences = head->occurrences;
			newNode->next = head->next;
			head->next = newNode;
			head = newNode->next;
		} else {
			head->value *= 2024;
			head = head->next;
		}
	}
}

void merge(Node* head) {
	Node* current = head;
	while (current != NULL) {
		Node* it = current;
		while (it->next != NULL) {
			if (it->next->value == current->value) {
				current->occurrences += it->next->occurrences;
				Node* temp = it->next;
				it->next = it->next->next;
			} else {
				it = it->next;
			}
		}
		current = current->next;
	}
}

long runLoop(Node* head, int cycles) {
	long entries = 0;
	for (int i = 0; i < cycles; i++) {
		doLoop(head);
		merge(head);
	}
	while (head != NULL) {
		entries += head->occurrences;
		head = head->next;
	}
    return entries;
}

int main(int argc, char** argv) {
	char input[1][40];
	readInput(input);
    Node * head = parseInput(input[0]);
    printf("Part 1: %ld\n", runLoop(head, 25));
	printf("Part 2: %ld\n", runLoop(head, 50));
	return 0;
}
