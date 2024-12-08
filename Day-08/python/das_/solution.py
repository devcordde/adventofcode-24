grid = open("input.txt").read().splitlines()

antennas = dict()
for row in range(len(grid)):
    for column in range(len(grid[0])):
        if grid[row][column] != ".":
            antennas.setdefault(grid[row][column], []).append((row, column))

def solve(part1=False):
    anti_nodes = set()
    for key, locations in antennas.items():
        for i in range(len(locations) - 1):
            for j in range(i + 1, len(locations)):
                diff_x, diff_y = (locations[i][0] - locations[j][0], locations[i][1] - locations[j][1])
                for k in range(part1, 2 if part1 else int(min(len(grid) / abs(diff_x), len(grid[0]) / abs(diff_y)))):
                    anti_nodes.add((locations[i][0] + k * diff_x, locations[i][1] + k * diff_y))
                    anti_nodes.add((locations[j][0] - k * diff_x, locations[j][1] - k * diff_y))

    return len(set(filter(lambda location: 0 <= location[0] < len(grid) and 0 <= location[1] < len(grid[0]), anti_nodes)))

print("Part 1:", solve(True))
print("Part 2:", solve())
