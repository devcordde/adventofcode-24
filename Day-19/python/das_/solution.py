def solve(pattern, sub_patterns):
    length = len(pattern)
    possibilities = [0] * (length + 1)
    possibilities[0] = 1

    for i in range(1, length + 1):
        for sub_pattern in sub_patterns:
            if i >= len(sub_pattern) and pattern[i - len(sub_pattern):i] == sub_pattern:
                possibilities[i] += possibilities[i - len(sub_pattern)]

    return possibilities[-1]

lines = open("input.txt").read().split("\n\n")
patterns = set(lines[0].split(", "))
towel_combinations = [solve(towel, patterns) for towel in lines[1].splitlines()]

print("Part 1:", sum(bool(towel_combination) for towel_combination in towel_combinations))
print("Part 2:", sum(towel_combinations))
