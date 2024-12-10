from typing import Tuple, List, Set

import numpy as np

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=10)
hiking_map = [list(map(int, line)) for line in lines]


def find_ascending_positions(x: int, y: int) -> List[Tuple[int, int]]:
    positions = []
    for x_delta, y_delta in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
        if 0 <= x + x_delta < len(hiking_map) and 0 <= y + y_delta < len(hiking_map[0]) \
                and hiking_map[x + x_delta][y + y_delta] - hiking_map[x][y] == 1:
            positions.append((x + x_delta, y + y_delta))

    return positions


# Part 1
def count_reached_hiking_ends(x: int, y: int) -> Set[Tuple[int, int]]:
    if hiking_map[x][y] == 9:
        return {(x, y)}

    ends = set()
    for next_x, next_y in find_ascending_positions(x, y):
        ends.update(count_reached_hiking_ends(next_x, next_y))

    return ends


total = 0
for i in range(len(hiking_map)):
    for j in range(len(hiking_map[0])):
        if hiking_map[i][j] == 0:
            total += len(count_reached_hiking_ends(i, j))

write(f"The sum of the <scores> of all trailheads is <{total}>.")


# Part 2
def position_to_vertex(position: Tuple[int, int]):
    return (position[0] * len(hiking_map)) + position[1]


dim = len(hiking_map) * len(hiking_map[0])
adjacency_matrix = np.zeros((dim, dim))

for i in range(len(hiking_map)):
    for j in range(len(hiking_map[0])):
        for neighbour in find_ascending_positions(i, j):
            adjacency_matrix[position_to_vertex((i, j))][position_to_vertex(neighbour)] = 1

power_matrix = np.linalg.matrix_power(adjacency_matrix, 9)
ratings = np.sum(power_matrix[np.nonzero(power_matrix)])

write(f"The sum of the <ratings> of all trailheads is <{int(ratings)}>.")
