from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=3)
instruction = "".join(lines)


def process(content: str) -> int:
    groups = re.findall(r"mul\([0-9]{1,3},[0-9]{1,3}\)", content)

    total = 0
    for match in groups:
        numbers = match.replace("mul", "").replace("(", "").replace(")", "").split(",")
        total += int(numbers[0]) * int(numbers[1])

    return total


# Part 1
write(f"Processing the mult operations results in a score of <{process(instruction)}>.")


# Part 2
def remove_skipped_operations(line: str) -> str:
    if "don't()" not in line:
        return line

    dont_index = line.index("don't()")

    if "do()" not in line[dont_index:]:
        return line[:dont_index]

    do_index = line.index("do()", dont_index)

    skip = line[:dont_index] + line[do_index:]
    return remove_skipped_operations(skip)


skipped_operations = remove_skipped_operations(instruction)
write(f"Skipping disabled operations results in a score of <{process(skipped_operations)}>.")
