grid = [list(line) for line in open("input.txt").readlines()]
position = next((a, b) for a in range(len(grid)) for b in range(len(grid[0])) if grid[a][b] == "^")
dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]

def solve(pos):
    dir_index = 0
    visited = set()
    loop = False

    while True:
        if (pos, dir_index) in visited:
            loop = True
            break

        visited.add((pos, dir_index))
        next_pos = (pos[0] + dirs[dir_index][0], pos[1] + dirs[dir_index][1])
        if not (0 <= next_pos[0] < len(grid) and 0 <= next_pos[1] < len(grid[0])):
            break

        if grid[next_pos[0]][next_pos[1]] == "#":
            dir_index = (dir_index + 1) % 4
        else:
            pos = next_pos

    return visited, loop

possible_positions = set(filter(lambda x: x != position, map(lambda x: x[0], solve(position)[0])))
print("Part 1:", len(possible_positions) + 1)

counter = 0
for possible_position in possible_positions:
    grid[possible_position[0]][possible_position[1]] = "#"
    if solve(position)[1]:
        counter += 1
    grid[possible_position[0]][possible_position[1]] = "."

print("Part 2:", counter)
