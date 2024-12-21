import re
from functools import cache

def shortest_paths(start, end, keys):
    start = keys[start]
    end = keys[end]
    paths = set()

    if (end[0], start[1]) in keys.values():
        path = "v" * (end[0] - start[0]) if end[0] >= start[0] else "^" * (-end[0] + start[0])
        path += ">" * (end[1] - start[1]) if end[1] >= start[1] else "<" * (-end[1] + start[1])
        paths.add(path)

    if (start[0], end[1]) in keys.values():
        path = ">" * (end[1] - start[1]) if end[1] >= start[1] else "<" * (-end[1] + start[1])
        path += "v" * (end[0] - start[0]) if end[0] >= start[0] else "^" * (-end[0] + start[0])
        paths.add(path)

    return paths

@cache
def solve(inputs, n, max_n):
    if n == 0:
        return len(inputs)

    current = "A"
    count = 0

    if n == max_n:
        keypad = numpad
    else:
        keypad = direction_pad

    for k in inputs + ("A" if n != max_n else ""):
        best_path = None

        for path in shortest_paths(current, k, keypad):
            if best_path:
                best_path = min(best_path, solve(path, n - 1, max_n))
            else:
                best_path = solve(path, n - 1, max_n)

        if n == 1:
            count += 1

        count += best_path
        current = k

    return count

numpad = {'7': (0, 0), '8': (0, 1), '9': (0, 2), '4': (1, 0), '5': (1, 1), '6': (1, 2), '1': (2, 0), '2': (2, 1), '3': (2, 2), '0': (3, 1), 'A': (3, 2)}
direction_pad = {'A': (0, 2), '^': (0, 1), '<': (1, 0), 'v': (1, 1), '>': (1, 2)}

combinations = open("input.txt").read().splitlines()
part1, part2 = 0, 0

for combination in combinations:
    part1 += solve(combination, 3, 3) * int(re.sub(r"\D", "", combination))
    part2 += solve(combination, 26, 26) * int(re.sub(r"\D", "", combination))

print("Part 1:", part1)
print("Part 2:", part2)
