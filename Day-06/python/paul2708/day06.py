from typing import List

from functools import cmp_to_key

from shared.paul2708.input_reader import *
from shared.paul2708.output import *

lines = read_plain_input(day=6, example=None)
grid = [list(line) for line in lines]


def find_start():
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] == "^":
                return i, j


start_position = find_start()
write_2d_array(grid)


def rotate(x, y):
    if x == -1 and y == 0:
        return 0, 1
    if x == 0 and y == 1:
        return 1, 0
    if x == 1 and y == 0:
        return 0, -1

    return -1, 0


def next_step(i, j, direction):
    x_delta, y_delta = direction

    if 0 <= i + x_delta < len(grid) and 0 <= j + y_delta < len(grid[0]):
        if grid[i + x_delta][j + y_delta] == ".":
            return i + x_delta, j + y_delta, direction
        else:
            return i, j, rotate(*direction)

    return -1, -1, direction


direction = (-1, 0)
i, j = start_position

grid[i][j] = "."

places = set()
places.add((i, j))

while i != -1:
    i, j, direction = next_step(i, j, direction)
    places.add((i, j))

print(i, j, direction)
print(len(places))
