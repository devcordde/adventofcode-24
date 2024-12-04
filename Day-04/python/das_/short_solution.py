grid = open("input.txt").read().splitlines()

print("Part 1:", sum(all(0 <= i + k * d[0] < len(grid) and 0 <= j + k * d[1] < len(grid[0]) and grid[i + k * d[0]][j + k * d[1]] == "XMAS"[k] for k in range(4)) for i in range(len(grid)) for j in range(len(grid[0])) if grid[i][j] == "X" for d in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]))
print("Part 2:", sum(grid[i - 1][j - 1] + grid[i + 1][j + 1] in (l := {"MS", "SM"}) and grid[i + 1][j - 1] + grid[i - 1][j + 1] in l for i in range(1, len(grid) - 1) for j in range(1, len(grid[0]) - 1) if grid[i][j] == "A"))
