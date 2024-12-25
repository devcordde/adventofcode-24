from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=25)
keys = []
locks = []

for i in range(0, len(lines), 8):
    if lines[i] == "#####":
        locks.append(lines[i:i + 7])
    else:
        keys.append(lines[i:i + 7])


def count_pins(schematic):
    is_lock = schematic[0] == "#####"
    count_char = "#" if is_lock else "."

    heights = []
    for i in range(len(schematic[0])):
        height = 0

        while height + 1 < len(schematic) and schematic[height + 1][i] == count_char:
            height += 1

        if not is_lock:
            height = 5 - height

        heights.append(height)

    return heights


pairs = 0
for lock in locks:
    for key in keys:
        if all([a + b < 6 for a, b in zip(count_pins(lock), count_pins(key))]):
            pairs += 1

write(f"There are <{pairs}> fitting lock/key pairs.")
