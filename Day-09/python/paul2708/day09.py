from tqdm import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import *
from shared.paul2708.utility import flatten

disk_layout = read_plain_input(day=9)[0]

# Part 1
expanded_disk_layout = flatten(
    [[j // 2 if j % 2 == 0 else -1 for _ in range(int(size))] for j, size in enumerate(disk_layout)])

checksum = 0
behind_index = len(expanded_disk_layout) - 1

for i in range(len(expanded_disk_layout)):
    if i >= behind_index:
        break

    if expanded_disk_layout[i] == -1:
        while expanded_disk_layout[behind_index] == -1:
            behind_index -= 1

        expanded_disk_layout[i] = expanded_disk_layout[behind_index]
        expanded_disk_layout[behind_index] = -1

    checksum += i * expanded_disk_layout[i]

write(f"The checksum after rearranging the memory is <{checksum}>.")

# Part 2
annotated_disk_layout = []

for i, size in enumerate(disk_layout):
    if int(size) != 0:
        annotated_disk_layout.append((int(size), i // 2 if i % 2 == 0 else -1))

total = 0
for i, (size, mem_id) in enumerate(tqdm(annotated_disk_layout)):
    if mem_id == -1:
        behind = len(annotated_disk_layout) - 1
        behind_size = annotated_disk_layout[behind][0]
        behind_mem_id = annotated_disk_layout[behind][1]

        while (behind_size > size or behind_mem_id == -1) and behind > i:
            behind -= 1
            behind_size = annotated_disk_layout[behind][0]
            behind_mem_id = annotated_disk_layout[behind][1]

        annotated_disk_layout[i] = (behind_size, behind_mem_id)
        annotated_disk_layout[behind] = (behind_size, -1)
        if size - behind_size > 0:
            annotated_disk_layout.insert(i + 1, (size - behind_size, -1))

expanded_i = 0
for size, mem_id in annotated_disk_layout:
    if mem_id != -1:
        total += sum([expanded_i + j for j in range(size)]) * mem_id

    expanded_i += size

write(f"The checksum after rearranging memory <without splitting> is <{total}>.")
