import re

def solve(bytes, coordinates):
    blocked = coordinates[:bytes]
    start = (0, 0)
    nodes = {start: 0}
    path = {start}

    while nodes:
        node = sorted(nodes.items(), key=lambda x: x[1])[0]
        nodes.pop(node[0])

        pos, weight = node
        path.add(pos)

        if pos == (70, 70):
            return weight

        for direction in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
            new_pos = (pos[0] + direction[0], pos[1] + direction[1])
            if new_pos in path or new_pos in blocked or new_pos[0] < 0 or new_pos[0] > 70 or new_pos[1] < 0 or new_pos[1] > 70:
                continue

            if nodes.get(new_pos) is None or nodes[new_pos] > weight:
                nodes[new_pos] = weight + 1

corrupted = [tuple(map(int, re.findall(r"(\d+),(\d+)", line)[0])) for line in open("input.txt").read().splitlines()]
part1 = solve(1024, corrupted)
print("Part 1:", part1)

min, max = [1024, len(corrupted)]
while min != max:
    if min == max:
        break

    mid = int((min + max) / 2)
    if solve(mid, corrupted) is None:
        max = mid - 1
    else:
        min = mid

y, x = corrupted[min]
print(f"Part 2: {x},{y}")
