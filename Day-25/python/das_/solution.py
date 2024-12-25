def is_lock(sub_grid):
    return any(sub_grid[0][k] == "#" for k in range(len(sub_grid[0])))

def convert(grid, reverse=False):
    for column in range(len(grid[0])):
        for row in range((len(grid) - 1) if reverse else 0, -1 if reverse else len(grid), -1 if reverse else 1):
            if grid[row][column] == ".":
                yield (len(grid) - row - 2) if reverse else (row - 1)
                break

lines = open("input.txt").read().split("\n\n")
locks = [list(convert(line.splitlines())) for line in lines if is_lock(line)]
keys = [list(convert(line.splitlines(), True)) for line in lines if not is_lock(line)]

print("Part 1:", sum(all(key[i] + lock[i] <= 5 for i in range(5)) for lock in locks for key in keys))
print("Merry Christmas!")
