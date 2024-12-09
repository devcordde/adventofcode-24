line = list(open("input.txt").read())

def part1():
    c = [int(i / 2) if i % 2 == 0 else "." for i in range(len(line)) for _ in range(int(line[i]))]

    dot_indexes = [i for i in range(len(c)) if c[i] == "."]
    for index in dot_indexes:
        if index > len(c) - 1:
            break
        if index == len(c) - 1:
            del c[len(c) - 1]
            break
        while c[len(c) - 1] == ".":
            del c[len(c) - 1]
        c[index] = c[len(c) - 1]
        del c[len(c) - 1]

    return sum([i * c[i] for i in range(len(c))])

def part2():
    c = [[int(i / 2) if i % 2 == 0 else ".", int(line[i])] for i in range(len(line))]

    for a, b in reversed(c):
        ind = c.index([a,b])
        if a != ".":
            for i in range(ind):
                if c[i][0] == "." and c[i][1] >= b:
                    c[i][1] -= b
                    c[ind] = [".", b]
                    c.insert(i, [a, b])
                    break

    ind = 0
    sum = 0
    for a, b in c:
        if a != ".":
            for j in range(ind, ind + b):
                sum += a * j
        ind += b

    return sum

print("Part 1:", part1())
print("Part 2:", part2())
