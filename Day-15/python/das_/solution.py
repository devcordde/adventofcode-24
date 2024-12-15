import copy

def update(pos):
    k = 1
    while grid[pos[0] + k * direction[0]][pos[1] + k * direction[1]] == "O":
        k += 1
    (x, y) = (pos[0] + k * direction[0], pos[1] + k * direction[1])
    if grid[x][y] == "#":
        return pos
    if k > 1:
        grid[x][y] = "O"
        grid[pos[0] + direction[0]][pos[1] + direction[1]] = "."
    return pos[0] + direction[0], pos[1] + direction[1]

def update2(pos):
    if direction in [(0, 1), (0, -1)]:
        k=1
        while grid2[pos[0]][pos[1] + k * direction[1]] in {"[", "]"}:
            k += 2
        (x, y) = (pos[0], pos[1] + k * direction[1])
        if grid2[x][y] == "#":
            return pos
        for i in range(k, 1, -1):
            if grid2[pos[0]][pos[1] + (i - 1) * direction[1]] =="[":
                grid2[pos[0]][pos[1] + i * direction[1]] ="["
            if grid2[pos[0]][pos[1] + (i - 1) * direction[1]] =="]":
                grid2[pos[0]][pos[1] + i * direction[1]] ="]"
        grid2[pos[0]][pos[1] + direction[1]] ="."
        return pos[0], pos[1] + direction[1]
    else:
        all_boxes = []
        starter_box = ()
        boxes = []

        if grid2[pos[0] + direction[0]][pos[1]] == "[":
            boxes.append(((pos[0] + direction[0], pos[1]), (pos[0] + direction[0], pos[1] + 1)))
            starter_box = ((pos[0] + direction[0], pos[1]), (pos[0] + direction[0], pos[1] + 1))
        elif grid2[pos[0] + direction[0]][pos[1]] == "]":
            boxes.append(((pos[0] + direction[0], pos[1] - 1), (pos[0] + direction[0], pos[1])))
            starter_box = ((pos[0] + direction[0], pos[1]), (pos[0] + direction[0], pos[1] - 1))
        done = False
        all_boxes += boxes
        while not done:
            done = True
            new_boxes = set()
            for box in boxes:
                for tile in box:
                    if grid2[tile[0] + direction[0]][tile[1]] == "[":
                        new_boxes.add(((tile[0] + direction[0], tile[1]), (tile[0] + direction[0], tile[1] + 1)))
                        done = False
                    if grid2[tile[0] + direction[0]][tile[1]] == "]":
                        new_boxes.add(((tile[0] + direction[0], tile[1] - 1), (tile[0] + direction[0], tile[1])))
                        done = False
            boxes = list(new_boxes)
            all_boxes  += boxes
        if not all_boxes and grid2[pos[0] + direction[0]][pos[1]]=="#":
            return pos
        for box in all_boxes:
            for tile in box:
                if grid2[tile[0] + direction[0]][tile[1]] == "#":
                    return pos
        for box in reversed(all_boxes):
            for tile in box:
                grid2[tile[0] + direction[0]][tile[1]] = grid2[tile[0]][tile[1]]
                grid2[tile[0]][tile[1]] = "."
        for tile in starter_box:
            grid2[tile[0]][tile[1]] = "."
        return pos[0] + direction[0], pos[1]

def calculate_gps(g, character):
    boxes = [(row, column) for row in range(len(g)) for column in range(len(g[0])) if g[row][column] == character]
    return sum(map(lambda box: box[0] * 100  + box[1], boxes))

parts = open("input.txt").read().split("\n\n")
grid = [list(line) for line in parts[0].splitlines()]
moves = parts[1].replace("\n", "")

position = [(row, column) for row in range(len(grid)) for column in range(len(grid[0])) if grid[row][column] == "@"][0]
directions = list(map(lambda d: (0, 1) if d == ">" else (0, -1) if d == "<" else (1, 0) if d == "v" else (-1, 0), moves))
for row in grid:
    if "@" in row:
        row[row.index('@')] = "."

grid2 = copy.deepcopy(grid)
position2 = (position[0], position[1] * 2)
for i, row in enumerate(grid2):
    new_row = []
    for char in row:
        if char == 'O':
            new_row.append('[')
            new_row.append(']')
        else:
            new_row.append(char)
            new_row.append(char)
    grid2[i] = new_row

for direction in directions:
    position = update(position)

print("Part 1:", calculate_gps(grid, "O"))

for direction in directions:
    position2 = update2(position2)

print("Part 2:", calculate_gps(grid2, "["))
