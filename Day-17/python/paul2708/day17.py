from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=17)
A = int(lines[0].split(": ")[1])
B = int(lines[1].split(": ")[1])
C = int(lines[2].split(": ")[1])

program = list(map(int, lines[4].replace("Program: ", "").split(",")))
instruction_pointer = 0
out = []


def to_combo(operand: int) -> int:
    return [0, 1, 2, 3, A, B, C][operand]


while 0 <= instruction_pointer < len(program):
    op_code = program[instruction_pointer]
    operand = program[instruction_pointer + 1]

    if op_code == 0:
        A = A // (2 ** to_combo(operand))
    elif op_code == 1:
        B = B ^ operand
    elif op_code == 2:
        B = to_combo(operand) % 8
    elif op_code == 3:
        if A != 0:
            instruction_pointer = operand
            continue
    elif op_code == 4:
        B = B ^ C
    elif op_code == 5:
        out.append(to_combo(operand) % 8)
    elif op_code == 6:
        B = A // (2 ** to_combo(operand))
    elif op_code == 7:
        C = A // (2 ** to_combo(operand))

    instruction_pointer += 2

write(f"The program outputs <{','.join(list(map(str, out)))}>.")
