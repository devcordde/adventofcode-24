lines = [list(map(int, line.split())) for line in open("input.txt").readlines()]
first, second = [sorted(map(lambda pair: pair[i], lines)) for i in range(2)]
print("Part 1:", sum([abs(a - b) for a, b in zip(first, second)]))
print("Part 2:", sum([element * second.count(element) for element in first]))
