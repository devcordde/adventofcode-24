from typing import List, Tuple

from tqdm import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import *
from shared.paul2708.utility import flatten

disk_layout = read_plain_input(day=9, example=None)[0]
expanded_disk_layout = flatten([[j // 2 if j % 2 == 0 else -1 for _ in range(int(size))] for j, size in enumerate(disk_layout)])

print(disk_layout)
print(expanded_disk_layout)
print(len(expanded_disk_layout))


total = 0
behind_index = len(expanded_disk_layout) - 1
already_done = set()

for i in range(len(expanded_disk_layout)):
    if i >= behind_index:
        break

    if expanded_disk_layout[i] == -1:
        while expanded_disk_layout[behind_index] == -1:
            behind_index -= 1

        expanded_disk_layout[i] = expanded_disk_layout[behind_index]
        expanded_disk_layout[behind_index] = -1
        already_done.add(behind_index)

    total += i * expanded_disk_layout[i]

print(expanded_disk_layout)

print(total)
