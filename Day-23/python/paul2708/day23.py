from typing import Collection

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=23, example=None)
links = [tuple(line.split("-")) for line in lines]
computers = set([a for a, b in links] + [b for a, b in links])

connected_to = set()

for a, b in links:
    connected_to.add((a, b))
    connected_to.add((b, a))


def is_connected_to(from_node: str, to_node: str) -> bool:
    return (from_node, to_node) in connected_to


def is_connected_to_all(from_nodes: Collection[str], to_node: str) -> bool:
    for from_node in from_nodes:
        if not is_connected_to(from_node, to_node):
            return False

    return True


# Part 1
connections = []

for a, b in links:
    for c in computers:
        if is_connected_to(a, c) and is_connected_to(b, c):
            connections.append({a, b, c})

matches = 0
for nodes in connections:
    if any(map(lambda node: node.startswith("t"), nodes)):
        matches += 1

write(f"<{matches // 3}> triple connections contain at least one computer <starting with t>.")

# Part 2
max_links = []

for a, b in links:
    curr_links = {a, b}
    curr_len = 0

    while curr_len != len(curr_links):
        curr_len = len(curr_links)

        for c in computers:
            if is_connected_to_all(curr_links, c):
                curr_links.add(c)

    if len(curr_links) > len(max_links):
        max_links = curr_links

password = ",".join(sorted(max_links))
write(f"The password is <{password}>.")
