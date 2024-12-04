from typing import List, Tuple

from shared.paul2708.input_reader import *
from shared.paul2708.output import *

grid = [list(line) for line in read_plain_input(day=4, example=1)]


def search_word(indices: List[Tuple[int, int]]) -> bool:
    if len(indices) != 4:
        raise Exception("Invalid indices")

    i = 0
    for coordinates in indices:
        x, y = coordinates

        if 0 <= x < len(grid) and 0 <= y < len(grid[0]):
            if grid[x][y] != "XMAS"[i]:
                return False

        i += 1

    return i == 3


def search_words(i: int, j: int) -> int:
    total = 0

    # Horizontal
    if search_word([(i, j), (i, j + 1), (i, j + 2), (i, j + 3)]):
        total += 1

    # Vertical
    if search_word([(i, j), (i + 1, j), (i + 2, j), (i + 3, j)]):
        total += 1

    # Diagonal
    if search_word([(i, j), (i + 1, j + 1), (i + 2, j + 2), (i + 3, j + 3)]):
        total += 1
    if search_word([(i, j), (i - 1, j - 1), (i - 2, j - 2), (i - 3, j - 3)]):
        total += 1

    # Horizontal
    if search_word(list(reversed([(i, j), (i, j + 1), (i, j + 2), (i, j + 3)]))):
        total += 1

    # Vertical
    if search_word(list(reversed([(i, j), (i + 1, j), (i + 2, j), (i + 3, j)]))):
        total += 1

    # Diagonal
    if search_word(list(reversed([(i, j), (i + 1, j + 1), (i + 2, j + 2), (i + 3, j + 3)]))):
        total += 1
    if search_word(list(reversed([(i, j), (i - 1, j - 1), (i - 2, j - 2), (i - 3, j - 3)]))):
        total += 1

    return total


write_2d_array(grid)
total = 0
for i in range(len(grid)):
    for j in range(len(grid[i])):
        total += search_words(i, j)

print(total)



