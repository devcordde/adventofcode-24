from typing import Tuple, List, Set

import numpy as np
from tqdm import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=11, example=None)
stones = [int(stone) for stone in lines[0].split(" ")]

def apply_rules(old_stones):
    new_stones = []

    for stone in old_stones:
        if stone == 0:
            new_stones.append(1)
        elif len(str(stone)) % 2 == 0:
            new_stones.append(int(str(stone)[:len(str(stone)) // 2]))
            new_stones.append(int(str(stone)[len(str(stone)) // 2:]))
        else:
            new_stones.append(stone * 2024)

    return new_stones

print(lines[0])

s = stones
for _ in range(25):
    s = apply_rules(s)


print(len(s))

from typing import Tuple, List, Set

import numpy as np
from tqdm import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=11, example=None)
stones = [int(stone) for stone in lines[0].split(" ")]

def group_by(numbers):
    mapping = {}
    for n in numbers:
        if not n in mapping:
            mapping[n] = numbers.count(n)

    return mapping

def add(mapping, key, value):
    if key not in mapping:
        mapping[key] = value
    else:
        mapping[key] = value + mapping[key]

print(group_by(stones))

def apply_rules(old_stones):
    new_stones = {}

    for stone, count in old_stones.items():
        if stone == 0:
            add(new_stones, 1, count)
        elif len(str(stone)) % 2 == 0:
            left_int = int(str(stone)[:len(str(stone)) // 2])
            right_int = int(str(stone)[len(str(stone)) // 2:])

            add(new_stones, left_int, count)
            add(new_stones, right_int, count)
        else:
            add(new_stones, stone * 2024, count)

    return new_stones

s = group_by(stones)
for _ in range(75):
    s = apply_rules(s)

t = 0
for _, count in s.items():
    t += count

print(t)
