from typing import Tuple, List

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=13)


def parse_positions(line: str) -> Tuple[int, int]:
    stripped = (line.replace("Button A: ", "")
                .replace("Button B: ", "")
                .replace("Prize: ", "")
                .replace("X+", "")
                .replace("Y+", "")
                .replace("X=", "")
                .replace("Y=", "")
                .replace(",", "")
                .split(" "))

    return int(stripped[0]), int(stripped[1])


simple_machines = []
enhanced_machines = []
for i in range(0, len(lines), 4):
    simple_machines.append([parse_positions(lines[i]),
                            parse_positions(lines[i + 1]),
                            parse_positions(lines[i + 2])])
    enhanced_machines.append([parse_positions(lines[i]),
                              parse_positions(lines[i + 1]),
                              (10000000000000 + parse_positions(lines[i + 2])[0],
                               10000000000000 + parse_positions(lines[i + 2])[1])])


def solve_machine(button_a: Tuple[int, int], button_b: Tuple[int, int], prize: Tuple[int, int]) -> Tuple[int, int]:
    a = button_a[0]
    b = button_b[0]
    c = button_a[1]
    d = button_b[1]

    denominator = a * d - b * c
    x = d * prize[0] + -b * prize[1]
    y = -c * prize[0] + a * prize[1]

    if x % denominator == 0 and y % denominator == 0 and x / denominator > 0 and y / denominator > 0:
        return x // denominator, y // denominator

    return 0, 0


def compute_tokens(machines: List[List[Tuple[int, int]]]) -> int:
    tokens = 0
    for machine in machines:
        i, j = solve_machine(*machine)
        tokens += i * 3 + j

    return tokens


# Run both parts
write(f"The solve all <simple> machines, <{compute_tokens(simple_machines)}> tokens are necessary.")
write(f"The solve all <enhanced> machines, <{compute_tokens(enhanced_machines)}> tokens are necessary.")
