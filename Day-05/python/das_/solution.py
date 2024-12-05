import re

content = open("input.txt").read().split("\n\n")
rules = [list(map(int, re.findall(r"(\d+)\|(\d+)", line)[0])) for line in content[0].splitlines()]
updates = [list(map(int, line.split(","))) for line in content[1].splitlines()]

predecessors = dict()
for rule in rules:
    predecessors.setdefault(rule[1], [])
    predecessors[rule[1]].append(rule[0])

s, t = 0, 0
for update in updates:
    valid, swapped = False, False
    while not valid:
        valid = True
        for i in range(len(update) - 1):
            for next_element in update[i + 1:]:
                if next_element in predecessors.get(update[i], []):
                    swapped, valid, ind = True, False, update.index(next_element)
                    update[i], update[ind] = update[ind], update[i]
                    break

    if swapped:
        t += update[int(len(update) / 2)]
    else:
        s += update[int(len(update) / 2)]

print("Part 1:", s)
print("Part 2:", t)
