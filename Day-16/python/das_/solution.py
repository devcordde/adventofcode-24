import math

def find_position(char):
    return next((row, column) for row in range(len(grid)) for column in range(len(grid[0])) if grid[row][column] == char)

grid = open("input.txt").read().splitlines()
start = find_position("S")
end = find_position("E")

positions = [(start, (0, 1), 0, set())]
position_weights = dict()
visited_nodes = set()
best_weight = math.inf

while positions:
    pos, direction, weight, path = positions.pop(0)
    path = set(path)
    path.add(pos)

    if pos not in position_weights:
        position_weights[pos] = weight

    if weight > best_weight:
        break

    if grid[pos[0]][pos[1]] == "E":
        best_weight = weight
        visited_nodes.update(path)

    for new_dir in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
        if new_dir[0] == -direction[0] and new_dir[1] == -direction[1]:
            continue

        new_pos = (pos[0] + new_dir[0], pos[1] + new_dir[1])
        new_weight = (weight + 1) if new_dir == direction else (weight + 1001)
        if new_pos in position_weights and new_weight > 1000 + position_weights[new_pos]:
            continue

        if 0 < new_pos[0] < len(grid) and 0 < new_pos[1] < len(grid[0]):
            if grid[new_pos[0]][new_pos[1]] != "#":
                positions.append((new_pos, new_dir, new_weight, path))

    positions = sorted(positions, key=lambda x: x[2])

print("Part 1:", best_weight)
print("Part 2:", len(visited_nodes))
