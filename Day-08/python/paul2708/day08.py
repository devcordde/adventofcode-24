from typing import Tuple, Callable

from shared.paul2708.input_reader import *
from shared.paul2708.output import *

lines = read_plain_input(day=8)
grid = [list(line) for line in lines]

antennas = {}

for i in range(len(grid)):
    for j in range(len(grid[0])):

        if grid[i][j] != ".":
            if grid[i][j] in antennas:
                antennas[grid[i][j]].append((i, j))
            else:
                antennas[grid[i][j]] = [(i, j)]


def is_in_grid(point: Tuple) -> bool:
    return 0 <= point[0] < len(grid) and 0 <= point[1] < len(grid[0])


def apply(func: Callable, a: Tuple, b: Tuple) -> Tuple:
    return tuple(map(lambda x: func(x[0], x[1]), zip(a, b)))


unique_points = set()
unique_points_any_direction = set()

for frequency, points in antennas.items():
    for i in range(len(points) - 1):
        for j in range(i + 1, len(points), 1):
            for k in range(max(len(grid), len(grid[0]))):
                diff = apply(lambda x, y: k * (x - y), points[j], points[i])

                point_up = apply(lambda x, y: (x - y), points[i], diff)
                point_down = apply(lambda x, y: (x + y), points[j], diff)

                for point in [point_up, point_down]:
                    if is_in_grid(point):
                        if k == 1:
                            unique_points.add(point)
                        unique_points_any_direction.add(point)

write(f"The locations of the antennas lead to <{len(unique_points)}> unique antinodes.")
write(
    f"The locations of the antennas lead to <{len(unique_points_any_direction)}> unique antinodes in <any direction>.")
