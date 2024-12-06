from typing import List, Tuple

from tqdm import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import *

lines = read_plain_input(day=6)
grid = [list(line) for line in lines]


def find_start_location() -> Tuple[int, int, Tuple[int, int]]:
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] == "^":
                return i, j, (-1, 0)

    raise Exception("could not find start position")


def next_location(x, y, direction) -> Tuple[int, int, Tuple[int, int]]:
    x_delta, y_delta = direction

    if 0 <= x + x_delta < len(grid) and 0 <= y + y_delta < len(grid[0]):
        if grid[x + x_delta][y + y_delta] == ".":
            return x + x_delta, y + y_delta, direction
        else:
            return x, y, (y_delta, -x_delta)

    return -1, -1, direction


start_location = find_start_location()

# Part 1
x, y, direction = start_location

grid[x][y] = "."

positions = set()
while x != -1:
    x, y, direction = next_location(x, y, direction)
    positions.add((x, y))

write(f"The guard visits <{len(positions)}> distinct positions.")


# Part 2
def runs_into_cycle(x, y, direction):
    locations = set()
    locations.add((x, y, direction))

    while x != -1:
        x, y, direction = next_location(x, y, direction)

        if (x, y, direction) in locations:
            return True

        locations.add((x, y, direction))

    return False


obstacles = 0
for x in tqdm(range(len(grid))):
    for y in range(len(grid[0])):
        if grid[x][y] in ["#", "^"]:
            continue

        grid[x][y] = "#"

        if runs_into_cycle(*start_location):
            obstacles += 1

        grid[x][y] = "."

write(f"<{obstacles}> new obstacles would lead to cycles.")
