m = open("input.txt").read().splitlines()
print("Part 1:", sum(all(0 <= i + k * d[0] < len(m) and 0 <= j + k * d[1] < len(m[0]) and m[i + k * d[0]][j + k * d[1]] == "XMAS"[k] for k in range(4)) for i in range(len(m)) for j in range(len(m[0])) if m[i][j] == "X" for d in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]))
print("Part 2:", sum(m[i - 1][j - 1] + m[i + 1][j + 1] in (l := {"MS", "SM"}) and m[i + 1][j - 1] + m[i - 1][j + 1] in l for i in range(1, len(m) - 1) for j in range(1, len(m[0]) - 1) if m[i][j] == "A"))
