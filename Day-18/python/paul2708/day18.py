import math
from typing import Tuple

import numpy as np
from scipy.sparse import csr_matrix
from scipy.sparse.csgraph import shortest_path
from tqdm import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=18)

SIZE = 71

memory = [(int(line.split(",")[0]), int(line.split(",")[1])) for line in lines]


def position_to_vertex(position: Tuple[int, int]) -> int:
    return (position[0] * SIZE) + position[1]


def compute_shortest_path(amount_of_bytes: int) -> np.ndarray:
    dim = SIZE * SIZE
    adjacency_matrix = np.zeros((dim, dim))

    for i in range(SIZE):
        for j in range(SIZE):
            for x, y in [(-1, 0), (1, 0), (0, 1), (0, -1)]:
                if 0 <= i + x < SIZE and 0 <= j + y < SIZE and not (i + x, j + y) in memory[:amount_of_bytes]:
                    adjacency_matrix[position_to_vertex((i, j))][position_to_vertex((i + x, j + y))] = 1

    dist_matrix = shortest_path(csgraph=csr_matrix(adjacency_matrix), indices=0)
    return dist_matrix[-1]


# Part 1
write(f"The shortest path after <1024 bytes> requires <{int(compute_shortest_path(1024))} steps>.")

# Part 2
lower = 1
upper = len(memory) - 1
index = (upper + lower) // 2

with tqdm(total=math.ceil(math.log(len(memory), 2))) as progress_bar:
    while not (compute_shortest_path(index - 1) != np.inf and compute_shortest_path(index) == np.inf):
        if compute_shortest_path(index) != np.inf:
            lower = index
        else:
            upper = index

        index = (upper + lower) // 2

        progress_bar.update(1)

write(f"The byte <{memory[index - 1]}> destroys the path.")
