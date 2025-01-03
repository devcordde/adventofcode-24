import itertools as it
import math

def safe(l):
    diffs = [a - b for (a, b) in it.pairwise(l)]
    return all(diff in range((j := int(math.copysign(1, diffs[0]))), 4 * j, j) for diff in diffs)

reports = [list(map(int, line.split())) for line in open("input.txt").readlines()]
print("Part 1:", sum(safe(report) for report in reports))
print("Part 2:", sum(any(safe(report[:i] + report[(i + 1):]) for i in range(len(report))) for report in reports))
