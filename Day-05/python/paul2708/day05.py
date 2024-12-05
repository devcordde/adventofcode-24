from typing import List, Tuple

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=5, example=1)
rules = [(int(line.split("|")[0]), int(line.split("|")[1])) for line in lines[:lines.index("")]]
updates = [list(map(int, line.split(","))) for line in lines[lines.index("") + 1:]]

must_be_before = {}
for x, _ in rules:
    must_be_before[x] = []
for x, y in rules:
    must_be_before[x].append(y)


def is_correct(rule: List[int]) -> bool:
    for i in range(len(rule) - 1):
        current, following = rule[i], rule[i + 1]

        if current not in must_be_before:
            return False
        if current in must_be_before and not following in must_be_before[current]:
            return False

    return True

print(must_be_before)

total = 0
for update in updates:
    if is_correct(update):
        print(update)
        total += update[len(update) // 2]

print(total)


def sort(update: List[int]):
    for n in range(len(update), 1, -1):
        for i in range(n - 1):
            if update[i] in must_be_before and update[i + 1] in must_be_before[update[i]]:
                before = update[i]
                after = update[i + 1]

                update[i] = after
                update[i + 1] = before

x = [61, 13, 29]
sort(x)
print(x)