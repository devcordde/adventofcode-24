from typing import List

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=3)

total = 0
for instruction in lines:

    x = re.findall(r"mul\([0-9]{1,3},[0-9]{1,3}\)", instruction)

    for a in x:
        total += int(a.replace("mul", "").replace("(", "").replace(")", "").split(",")[0]) * int(a.replace("mul", "").replace("(", "").replace(")", "").split(",")[1])

print(total)

lines = read_plain_input(day=3, example=1)

total = 0
for instruction in lines:
    print(instruction)
    instruction = re.sub(r"don't\(\)(.*?)do\(\)", r"", instruction)
    print(instruction)
    instruction = re.sub(r"don't\(\)?(.*)", r"", instruction)
    print(instruction)

    x = re.findall("mul\([0-9]{1,3},[0-9]{1,3}\)", instruction)
    for a in x:
        total += int(a.replace("mul", "").replace("(", "").replace(")", "").split(",")[0]) * int(
            a.replace("mul", "").replace("(", "").replace(")", "").split(",")[1])


print(total)


def validate(line: str):
    i = 0
    # Alles entfernen zwischen dont() und do() und dont()... (wenn kein do() mehr kommt)
    while i < len(line):
