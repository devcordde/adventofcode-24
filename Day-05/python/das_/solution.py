content = open("input.txt").read().split("\n\n")
rules = [tuple(map(int, line.split("|"))) for line in content[0].splitlines()]
updates = [list(map(int, line.split(","))) for line in content[1].splitlines()]

predecessors = dict()
for rule in rules:
    predecessors.setdefault(rule[1], []).append(rule[0])

part1, part2 = 0, 0
for update in updates:
    swapped = False
    for i in range(len(update) - 1):
        for j in range(i + 1, len(update)):
            if update[j] in predecessors.get(update[i], []):
                swapped = True
                update[i], update[j] = update[j], update[i]

    if swapped:
        part2 += update[int(len(update) / 2)]
    else:
        part1 += update[int(len(update) / 2)]

print("Part 1:", part1)
print("Part 2:", part2)
