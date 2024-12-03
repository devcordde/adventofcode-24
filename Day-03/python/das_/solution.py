from re import findall
from functools import reduce

def multiply(statement):
    return reduce(lambda a, b: int(a) * int(b), findall(r"mul\((\d{1,3}),(\d{1,3})\)", statement)[0])

def calculate_result(acc, element):
    if element == "don't()":
        return False, acc[1], acc[2]
    elif element == "do()":
        return True, acc[1], acc[2]

    value = multiply(element)
    return acc[0], acc[1] + value, acc[2] + (value if acc[0] else 0)

statements = findall(r"(do\(\)|don't\(\)|mul\(\d{1,3},\d{1,3}\))", "".join(open("input.txt").readlines()))
result = reduce(calculate_result, statements, (True, 0, 0))
print("Part 1:", result[1])
print("Part 2:", result[2])
