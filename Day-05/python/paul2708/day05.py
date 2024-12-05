from typing import List

from functools import cmp_to_key

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=5)
rules = [tuple(map(int, line.split("|"))) for line in lines[:lines.index("")]]
updates = [list(map(int, line.split(","))) for line in lines[lines.index("") + 1:]]

must_be_before = {}
for x, _ in rules:
    must_be_before[x] = []
for x, y in rules:
    must_be_before[x].append(y)


# Part 1
def is_correct(rule: List[int]) -> bool:
    for i in range(len(rule) - 1):
        current, following = rule[i], rule[i + 1]

        if current in must_be_before and not following in must_be_before[current]:
            return False

    return True


# Part 2
def compare(a: int, b: int) -> int:
    return -1 if b in must_be_before[a] else 1


# Run both parts
part1 = 0
part2 = 0
for update in updates:
    if is_correct(update):
        part1 += update[len(update) // 2]
    else:
        corrected_update = sorted(update, key=cmp_to_key(compare))
        part2 += corrected_update[len(corrected_update) // 2]

write(f"The sum of all correct updated is <{part1}>.")
write(f"The sum of all incorrect updated is <{part2}>.")
