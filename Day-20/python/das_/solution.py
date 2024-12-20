from functools import cache

@cache
def is_in_bounds(x, y):
    return 0 <= x < len(grid) and 0 <= y < len(grid[0])

def find(char):
    return next((row, column) for row in range(len(grid)) for column in range(len(grid[0])) if grid[row][column] == char)

def bfs(pos, starting_weight=0):
    locations = {pos: starting_weight}

    while locations:
        location = list(locations)[0]
        weight = locations.pop(location)

        if location in weights:
            return initial_time - weights[location] + weight

        if location == end:
            return weight

        weights[location] = weight

        for dx, dy in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
            new_x, new_y = location[0] + dx, location[1] + dy
            if is_in_bounds(new_x, new_y) and grid[new_x][new_y] != "#" and (new_x, new_y) not in weights:
                locations[(new_x, new_y)] = weight + 1

grid = open("input.txt").read().splitlines()
start = find("S")
end = find("E")

weights = dict()
initial_time = bfs(start)

part1 = 0
for (x, y), weight in weights.items():
    for dx, dy in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
        new_x, new_y = x + 2 * dx, y + 2 * dy
        if is_in_bounds(new_x, new_y):
            if grid[x + dx][y + dy] == "#" and grid[new_x][new_y] != "#":
                new_time = bfs((new_x, new_y), weights[(x, y)] + 2)
                if new_time < initial_time:
                    time_saved = initial_time - new_time
                    if time_saved >= 100:
                        part1 += 1

print("Part 1:", part1)

part2 = 0
used_cheats = set()
valid_moves = [(dx, dy) for dx in range(-20, 21) for dy in range(-20, 21) if abs(dx) + abs(dy) <= 20]

for pos, weight in weights.items():
    for dx, dy in valid_moves:
        new_pos = pos[0] + dx, pos[1] + dy
        if is_in_bounds(*new_pos):
            if grid[new_pos[0]][new_pos[1]] != "#":
                if (pos, new_pos) not in used_cheats:
                    used_cheats.add((pos, new_pos))

                cost = abs(dx) + abs(dy)
                new_time = bfs(new_pos, weights[pos] + cost)

                time_saved = initial_time - new_time
                if time_saved >= 100:
                    part2 += 1

print("Part 2:", part2)
