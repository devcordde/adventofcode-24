import itertools as it
import math

def safe(l):
    t = [a - b for (a, b) in it.pairwise(l)]
    return all(t[k] in range((j := int(math.copysign(1, t[0]))), 4*j, j) for k in range(len(t)))

reports = [list(map(int, line.split())) for line in open("input.txt").readlines()]
counter = [0, 0]
for report in reports:
    if safe(report):
        counter = [e + 1 for e in counter]
    else:
        counter[1] += 1 if any(safe(report[:i] + report[(i + 1):]) for i in range(len(report))) else 0

print("Part 1:", counter[0])
print("Part 2:", counter[1])
