from typing import Tuple, List

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=14, example=None)

robots = []
for i, line in enumerate(lines):
    p_x = int(line.split(" ")[0].replace("p=", "").split(",")[0])
    p_y = int(line.split(" ")[0].replace("p=", "").split(",")[1])
    v_x = int(line.split(" ")[1].replace("v=", "").split(",")[0])
    v_y = int(line.split(" ")[1].replace("v=", "").split(",")[1])

    robots.append([i, (p_x, p_y), (v_x, v_y)])

print(robots)

grid_width = 101
grid_height = 103

def simulate(p, v):
    return (v[0] + p[0]) % grid_width, (v[1] + p[1]) % grid_height


for _ in range(100):
    for i in range(len(robots)):
        j, p, v = robots[i]

        robots[i] = [j, simulate(p, v), v]


print(sorted([(p, j) for j, p, _ in robots]))
first = [(j, p) for j, p, _ in robots if 0 <= p[0] < grid_width // 2 and 0 <= p[1] < grid_height // 2]
second = [(j, p) for j, p, _ in robots if grid_width // 2 < p[0] and 0 <= p[1] < grid_height // 2]
third = [(j, p) for j, p, _ in robots if 0 <= p[0] < grid_width // 2 and grid_height // 2 < p[1]]
fourth = [(j, p) for j, p, _ in robots if grid_width // 2 < p[0] and grid_height // 2 < p[1]]
print(len(first) * len(second) * len(third) * len(fourth))
