import math
from typing import Tuple, List, Set

import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=23, example=None)
links = [tuple(line.split("-")) for line in lines]
computers = set([a for a, b in links] + [b for a, b in links])


def is_connected_to(from_node, to_node):
    for a, b in links:
        if from_node == a and to_node == b or from_node == b and to_node == a:
            return True

    return False


connections = []

for a, b in tqdm.tqdm(links):
    for c in computers:
        if is_connected_to(a, c) and is_connected_to(b, c):
            if {a, b, c} in connections:
                continue

            connections.append({a, b, c})

res = 0
for nodes in tqdm.tqdm(connections):
    if any(map(lambda n: n.startswith("t"), nodes)):
        res += 1

print(connections)
print(len(connections))
print(res)
