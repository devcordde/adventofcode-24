from typing import List, Tuple

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

grid = [list(line) for line in read_plain_input(day=4)]


# Part 1
def search_xmas(indices: List[Tuple[int, int]]) -> bool:
    idx = 0
    for i, j in indices:
        if 0 <= i < len(grid) and 0 <= j < len(grid[0]) and grid[i][j] == "XMAS"[idx]:
            idx += 1

    return idx == 4


def search_in_all_directions(i: int, j: int) -> int:
    indices_to_check = [
        # Horizontal
        [(i, j + delta) for delta in range(0, 4)],
        # Vertical
        [(i + delta, j) for delta in range(0, 4)],
        # Diagonal (left-to-right)
        [(i + delta, j + delta) for delta in range(0, 4)],
        # Diagonal (right-to-left)
        [(i + delta, j - delta) for delta in range(0, 4)],
    ]
    indices_to_check = indices_to_check + list(map(reversed, indices_to_check))

    return len(list(filter(search_xmas, indices_to_check)))


# Part 2
def matches_xmas(i: int, j: int) -> bool:
    if 0 <= i + 2 < len(grid) and 0 <= j + 2 < len(grid[0]):
        if grid[i + 1][j + 1] != "A":
            return False
        if ((grid[i][j] == "M" and grid[i + 2][j + 2] == "S") or (
                grid[i][j] == "S" and grid[i + 2][j + 2] == "M")) and (
                (grid[i][j + 2] == "M" and grid[i + 2][j] == "S") or (grid[i][j + 2] == "S" and grid[i + 2][j] == "M")):
            return True

    return False


# Run both parts
xmas_counter = 0
x_counter = 0

for x in range(len(grid)):
    for y in range(len(grid[x])):
        xmas_counter += search_in_all_directions(x, y)

        if matches_xmas(x, y):
            x_counter += 1

write(f"There are a total of <{xmas_counter}> XMAS variations hidden.")
write(f"There are a total of <{x_counter}> X-formatted MAS variations hidden.")
