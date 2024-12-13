import re

def calculate_score(target):
    tb = (target[1] * A[0] - target[0] * A[1]) / (B[1] * A[0] - B[0] * A[1])
    ta = (target[0] - B[0] * tb) / A[0]
    return int(ta * 3 + tb) if ta.is_integer() and tb.is_integer() else 0

machines = [line.splitlines() for line in open("input.txt").read().split("\n\n")]
part1, part2 = 0, 0

for machine in machines:
    A, B, C = map(lambda line: list(map(int, re.findall(r"(\d+)\D+(\d+)", line)[0])), machine)
    part1 += calculate_score(C)
    part2 += calculate_score((C[0] + 10000000000000, C[1] + 10000000000000))

print("Part 1:", part1)
print("Part 2:", part2)
