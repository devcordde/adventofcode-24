from typing import Tuple, List

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=15, example=None)
locations = [list(line) for line in lines[:lines.index("")]]
instructions = "".join(lines[lines.index("") + 1:])

borders = set()
boxes = set()
position = -1, -1

for i in range(len(locations)):
    for j in range(len(locations[0])):
        if locations[i][j] == "@":
            position = i, j
        elif locations[i][j] == "#":
            borders.add((i, j))
        elif locations[i][j] == "O":
            boxes.add((i, j))

print("Borders", borders)
print("Boxes", boxes)
print("Position", position)


def find_consecutive_positions(positions, x, y, direction):
    result = [(x, y)]

    pos = x + direction[0], y + direction[1]
    while pos in positions:
        result.append(pos)
        pos = pos[0] + direction[0], pos[1] + direction[1]

    return result


def push_boxes(position, direction):
    consecutive_boxes = find_consecutive_positions(boxes, *position, direction)
    print("Consecutive boxes", consecutive_boxes)
    last_box = consecutive_boxes[-1]

    new_location = last_box[0] + direction[0], last_box[1] + direction[1]

    print("Check free push location", new_location)

    if new_location in borders:
        return False

    if new_location in boxes:
        raise Exception("Should not happen")

    to_be_added = []
    for b in consecutive_boxes:
        boxes.remove(b)
        to_be_added.append((b[0] + direction[0], b[1] + direction[1]))
        print("Replace", b, "with", (b[0] + direction[0], b[1] + direction[1]))
    for x in to_be_added:
        boxes.add(x)



    print(boxes)
    return True


operators = {
    "^": (-1, 0),
    "v": (1, 0),
    "<": (0, -1),
    ">": (0, 1),
}

for instruction in instructions:
    print("===")
    print("Instruction", instruction, "Position", position)

    direction = operators[instruction]
    new_pos = position[0] + direction[0], position[1] + direction[1]

    print("New (possible) Position", new_pos)

    if new_pos in borders:
        print("Skip because border")
        continue
    elif new_pos in boxes:
        print("Box in front")
        if push_boxes(new_pos, direction):
            print("Pushed boxes")
            position = new_pos
        else:
            print("Could not push boxes")
    else:
        print("Free")
        position = new_pos

def compute_gps(position):
    return 100 * position[0] + position[1]

total = 0
for b in boxes:
    total += compute_gps(b)

print(total)
