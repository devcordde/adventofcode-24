from typing import Tuple, Callable, List

from shared.paul2708.input_reader import *

lines = read_plain_input(day=10, example=None)
hiking_map = [list(map(lambda x: int(x) if x != "." else 100, line)) for line in lines]

history = []

def find_next_paths(x: int, y: int) -> List[Tuple[int, int]]:
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]

    positions = []
    for x_delta, y_delta in directions:
        if 0 <= x + x_delta < len(hiking_map) and 0 <= y + y_delta < len(hiking_map[0]) \
            and hiking_map[x + x_delta][y + y_delta] - hiking_map[x][y] == 1:
            positions.append((x + x_delta, y + y_delta))

    return positions

def count_paths(x: int, y: int) -> set():
    if hiking_map[x][y] == 9:
        return {(x, y)}

    positions = find_next_paths(x, y)

    if len(positions) == 0:
        return set()

    total = set()

    for i, j in positions:
        for count_path in count_paths(i, j):
            total.add(count_path)

    return total

total = 0
for i in range(len(hiking_map)):
    for j in range(len(hiking_map[0])):
        if hiking_map[i][j] == 0:
            total += len(count_paths(i, j))

print(hiking_map)
print(total)
