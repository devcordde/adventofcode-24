from typing import Tuple, List, Set

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=12)
grid = [list(line) for line in lines]

already_added = set()


def find_region(region_id: str, start_x: int, start_y: int) -> List[Tuple[int, int]]:
    if (start_x, start_y) in already_added or grid[start_x][start_y] != region_id:
        return []

    region = [(start_x, start_y)]
    already_added.add((start_x, start_y))

    for i, j in [(-1, 0), (1, 0), (0, 1), (0, -1)]:
        x_new, y_new = start_x + i, start_y + j

        if 0 <= x_new < len(grid) and 0 <= y_new < len(grid[0]) and grid[x_new][y_new] == region_id:
            region += find_region(region_id, x_new, y_new)

    return region


regions = []
for x in range(len(grid)):
    for y in range(len(grid[0])):
        region = find_region(grid[x][y], x, y)
        if len(region) != 0:
            regions.append(region)


# Part 1
def compute_perimeter(blocks: List[Tuple[int, int]]) -> int:
    perimeter = 4 * len(blocks)
    for x, y in blocks:
        for i, j in blocks:
            if x == i and y == j:
                continue

            if x == i and abs(y - j) == 1 or y == j and abs(x - i) == 1:
                perimeter -= 1

    return perimeter


total_price = 0
for region in regions:
    total_price += len(region) * compute_perimeter(region)

write(f"The total price using <perimeters> is <{total_price}>.")


# Part 2
# This method also returns the perimeter by taking the length of the set.
def determine_fences(blocks: List[Tuple[int, int]]) -> Set[Tuple[int, int, str]]:
    fences = set()

    for x, y in blocks:
        for i, j, direction in [(1, 0, "down"), (-1, 0, "up"), (0, 1, "right"), (0, -1, "left")]:
            if (x + i, y + j) not in blocks:
                fences.add((x, y, direction))

    return fences


def reduce_neighbours(tuples: List[Tuple[int, int]]) -> List[Tuple[int, int]]:
    for i in range(len(tuples) - 1):
        for j in range(i, len(tuples)):
            if tuples[i][0] == tuples[j][0] and abs(tuples[i][1] - tuples[j][1]) == 1 or \
                    tuples[i][1] == tuples[j][1] and abs(tuples[i][0] - tuples[j][0]) == 1:
                del tuples[i]
                return reduce_neighbours(tuples)

    return tuples


def compute_sides(region: List[Tuple[int, int]]) -> int:
    fences = sorted(determine_fences(region))

    sides = 0

    for direction in ["up", "down", "left", "right"]:
        tuples = [(a, b) for a, b, c in fences if c == direction]
        sides += len(reduce_neighbours(tuples))

    return sides


total_price = 0
for region in regions:
    total_price += len(region) * compute_sides(region)

write(f"The total price using <sides> is <{total_price}>.")
