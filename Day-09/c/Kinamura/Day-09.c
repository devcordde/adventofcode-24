#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct node;
typedef struct node {
    int id;
    int pos;
    struct node* next;
    struct node* prev;
} Node;

struct NodeBlock;
typedef struct NodeBlock {
    int id;
    int size;
    int freeSpace;
    struct NodeBlock* next;
    struct NodeBlock* prev;
} NodeBlock;

void pack(Node* head, Node* tail) {
    while (1) {
        if (head->pos >= tail->pos) return;
        if (head->pos + 1 == head->next->pos) {
            head = head->next;
            continue;
        }
        tail = tail->prev;
        tail->next->next = head->next;
        tail->next->prev = head;
        head->next->prev = tail->next;
        tail->next = NULL;
        head->next = head->next->prev;
        head = head->next;
        head->pos = head->prev->pos + 1;
    }
}

void parseInput(char data[], int length) {
    int id = 0, pos = 0;
    Node* curr = calloc(sizeof(Node),1);
    for (int i = 0; i < length; i++) {
        int curNum = data[i] - '0';
        if (i % 2 == 0) {
            for (int j = 0; j < curNum; j++) {
                Node* temp = calloc(sizeof(Node),1);
                temp->id = id;
                temp->pos = pos++;
                temp->next = NULL;
                curr->next = temp;
                temp->prev = curr;
                curr = temp;
            }
            id++;
        } else { pos += curNum; }
    }
    Node * tail = curr;
    Node * head = tail;
    while (head->prev != NULL) {
        head = head->prev;
    }
    head = head->next;
    pack(head, tail);
    long sum = 0;
    Node* curr2 = head;
    while (curr2 != NULL) {
        sum += curr2->pos * curr2->id;
        curr2 = curr2->next;
    }
    printf("Sum: %ld\n", sum);
}

void pack2(char data[], int length) {
    NodeBlock start = {0, data[0] - '0', data[1] - '0'};
    NodeBlock* end = &start;
    for (int i = 2; i < length; i += 2) {
        NodeBlock* currEnd = calloc(1, sizeof(NodeBlock));
        currEnd->id = i / 2;
        currEnd->size = data[i] - '0';
        if (i + 1 < length) {
            currEnd->freeSpace = data[i + 1] - '0';
        }
        end->next = currEnd;
        currEnd->prev = end;
        end = currEnd;
    }
    NodeBlock* currEnd = end;
    while (currEnd != NULL) {
        NodeBlock* prev = currEnd->prev;
        for (NodeBlock* currStart = &start; currStart != currEnd && currStart != NULL; currStart = currStart->next) {
            if (currStart->freeSpace >= currEnd->size) {
                if (currEnd->prev != NULL) {
                    currEnd->prev->next = currEnd->next;
                    currEnd->prev->freeSpace += currEnd->size + currEnd->freeSpace;
                }
                if (currEnd->next != NULL) {
                    currEnd->next->prev = currEnd->prev;
                }
                if (currStart->next != NULL) {
                    currStart->next->prev = currEnd;
                    currEnd->next = currStart->next;
                }
                currEnd->freeSpace = currStart->freeSpace - currEnd->size;
                currStart->freeSpace = 0;
                currStart->next = currEnd;
                currEnd->prev = currStart;
                break;
            }
        }
        currEnd = prev;
    }
    long sum = 0;
    int position = 0;
    NodeBlock* n = &start;
    while (n != NULL) {
        for (int i = 0; i < n->size; i++) sum += n->id * position++;
        for (int i = 0; i < n->freeSpace; i++) position ++;
        n = n->next;
    }
    printf("Sum2: %ld\n", sum);
}

int main() {
    char data[20002];
    FILE *input = fopen("./09input.txt", "r");
    fscanf(input, "%s ", &data);
    int length = strlen(data);
    parseInput(data, length);
    pack2(data, length);
}
