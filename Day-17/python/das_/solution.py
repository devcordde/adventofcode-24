import re

def combo(x, A, B, C):
    match x:
        case 0 | 1 | 2 | 3:
            return x
        case 4:
            return A
        case 5:
            return B
        case 6:
            return C

def part1(A, B, C):
    output = []
    instruction_pointer = 0

    while instruction_pointer < len(P):
        opcode, operand = P[instruction_pointer:instruction_pointer + 2]
        instruction_pointer += 2

        match opcode:
            case 0:
                A = int(A / 2 ** combo(operand, A, B, C))
            case 1:
                B = B ^ operand
            case 2:
                B = combo(operand, A, B, C) % 8
            case 3:
                if A != 0:
                    instruction_pointer = operand
            case 4:
                B = B ^ C
            case 5:
                output.append(combo(operand, A, B, C) % 8)
            case 6:
                B = int(A / 2 ** combo(operand, A, B, C))
            case 7:
                C = int(A / 2 ** combo(operand, A, B, C))
    return output

def calculate_next(A, step):
    possible_As = []

    for new_A in range(8 * A, 8 * A + 8):
        B, C = 0, 0
        operand = part1(new_A, B, C)[0]
        if operand == step:
            possible_As.append(new_A)

    return possible_As

lines = open("input.txt").read().splitlines()
P = list(map(int, re.findall(r"\d+", lines[4])))
A = int(re.findall(r"\d+", lines[0])[0])

print("Part 1:", ",".join(map(str, part1(A, 0, 0))))

all_As = [[0]]
for step in reversed(P):
    new_As = []
    for A in all_As[0]:
        possible_As = calculate_next(A, step)
        new_As += possible_As

    all_As.insert(0, new_As)

print("Part 2:", all_As[0][0])
