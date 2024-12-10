import itertools

def solve(row, column, n=0):
    if not (0 <= row < len(grid) and 0 <= column < len(grid[0])) or grid[row][column] != n:
        return []
    elif n == 9:
        return [(row, column)]
    return [l for d in [(1, 0), (0, 1), (-1, 0), (0, -1)] for l in solve(row + d[0], column + d[1], n + 1)]

grid = [list(map(int, line.strip())) for line in open("input.txt")]
paths = [solve(*pos) for pos in itertools.product(range(len(grid)), range(len(grid[0])))]
print("Part 1:", sum(len(set(path)) for path in paths))
print("Part 2:", sum(len(path) for path in paths))
