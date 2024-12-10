import itertools

def solve(row, column, n=0):
    if not (0 <= row < len(grid) and 0 <= column < len(grid[0])):
        return []

    if grid[row][column] != n:
        return []

    if n == 9:
        return [(row, column)]

    return (solve(row + 1, column, n + 1) +
            solve(row, column + 1, n + 1) +
            solve(row - 1, column, n + 1) +
            solve(row, column - 1, n + 1))

grid = [list(map(int, line.strip())) for line in open("input.txt")]
paths = [solve(*pos) for pos in itertools.product(range(len(grid)), range(len(grid[0])))]
print("Part 1:", sum(len(set(path)) for path in paths))
print("Part 2:", sum(len(path) for path in paths))
