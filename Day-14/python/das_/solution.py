import functools
import math
import re

def tuple_add_mod(a, b):
    return (a[0] + b[0]) % 101, (a[1] + b[1]) % 103

def display_map(r):
    r = list(map(lambda d: d[0], r))
    for u in range(103):
        for i in range(101):
            if (i, u) in r:
                print(r.count((i, u)), end="")
            else:
                print(".", end="")
        print()
    print()

lines = [re.findall(r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)", line)[0] for line in open("input.txt")]
robots = list(map(lambda v: ((int(v[0]), int(v[1])), (int(v[2]), int(v[3]))), lines))

part1_robots = []
part2 = math.nan

for second in range(25_000):
    if second == 100:
        part1_robots = robots.copy()

    for k, robot in enumerate(robots):
        robots[k] = (tuple_add_mod(robot[0], robot[1]), robot[1])

    coordinates = list(map(lambda d: d[0], robots))
    if len(coordinates) == len(set(coordinates)):
        part2 = second + 1
        print(f"Christmas tree at {second}:")
        display_map(robots)
        break # If this doesn't find a valid solution for part 2, try removing the break

quadrants = [0, 0, 0, 0]
for robot in part1_robots:
    x, y = robot[0]
    if x <= 49 and y <= 50:
        quadrants[0] += 1
    elif x > 50 and y <= 50:
        quadrants[1] += 1
    elif x <= 49 and y > 51:
        quadrants[2] += 1
    elif x > 50 and y > 51:
        quadrants[3] += 1

print("Part 1:", functools.reduce(lambda acc, a: acc * a, quadrants, 1))
print("Part 2:", part2)
