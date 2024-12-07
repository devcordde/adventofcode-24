from typing import List

import itertools

from tqdm import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import *

lines = read_plain_input(day=7)
equations = [(int(line.split(": ")[0]), list(map(int, line.split(": ")[1].split(" ")))) for line in lines]

operators = {
    "*": lambda acc, val: acc * val,
    "+": lambda acc, val: acc + val,
    "||": lambda acc, val: int(f"{acc}{val}")
}


def sum_correct_equations(allowed_operations: List[str], show_progress: bool = False):
    total = 0

    iterator = tqdm(equations) if show_progress else equations
    for test_value, values in iterator:
        combinations = list(itertools.product(allowed_operations, repeat=len(values) - 1))

        for combination in combinations:
            combination_result = values[0]

            for i in range(1, len(values)):
                combination_result = operators[combination[i - 1]](combination_result, values[i])
                if combination_result > test_value:
                    break

            if combination_result == test_value:
                total += test_value
                break

    return total


write(f"The sum of the correct equations using <* and +> results in <{sum_correct_equations(['*', '+'])}>.")
write(
    f"The sum of the correct equations using <*, +, and ||> results in <{sum_correct_equations(['*', '+', '||'], show_progress=True)}>.")
