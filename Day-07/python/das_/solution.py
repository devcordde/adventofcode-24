import itertools
from tqdm import tqdm

equations = list(map(lambda x: (int(x[0]), tuple(map(int, x[1].split()))), [line.split(": ") for line in open("input.txt").readlines()]))

def solve(allowed_operators, skipped=frozenset()):
    total = 0
    valid_equations = set()

    for i in tqdm(range(len(equations))):
        if i in skipped:
            continue

        expected_result, numbers = equations[i]
        for operator_combination in itertools.product(*(allowed_operators for _ in range(len(numbers) - 1))):
            x = numbers[0]
            for j in range(1, len(numbers)):
                match operator_combination[j - 1]:
                    case 0:
                        x += numbers[j]
                    case 1:
                        x *= numbers[j]
                    case 2:
                        x = int(str(x) + str(numbers[j]))

            if x == expected_result:
                total += x
                valid_equations.add(i)
                break

    return total, valid_equations

part1 = solve([0, 1])
print("Part 1:", part1[0])
print("Part 2:", part1[0] + solve([0, 1, 2], part1[1])[0])
