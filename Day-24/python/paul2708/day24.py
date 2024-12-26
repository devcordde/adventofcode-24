from typing import Tuple, List, Dict

from tqdm import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=24, example=None)
initialization = [(line.split(": ")[0], int(line.split(": ")[1])) for line in lines[:lines.index("")]]
gates = [(line.split(" ")[1], line.split(" ")[0], line.split(" ")[2], line.split(" ")[4]) for line in lines[lines.index("") + 1:]]

wires = set([a for a, _ in initialization])
wires.update([a for _, a, _, _ in gates])
wires.update([b for _, _, b, _ in gates])
wires.update([c for _, _, _, c in gates])

print(initialization)
print(gates)
print(wires)

known_outputs = dict()
for wire, val in initialization:
    known_outputs[wire] = val

def is_one(wire):
    return wire in known_outputs and known_outputs[wire] == 1

def is_zero(wire):
    return wire in known_outputs and known_outputs[wire] == 0


while len(known_outputs) != len(wires):
    for operation, op1, op2, output in gates:
        if operation == "AND" and (is_zero(op1) or is_zero(op2)):
            known_outputs[output] = 0
        elif operation == "AND" and (is_one(op1) and is_one(op2)):
            known_outputs[output] = 1
        if operation == "OR" and (is_one(op1) or is_one(op2)):
            known_outputs[output] = 1
        elif operation == "OR" and (is_zero(op1) and is_zero(op2)):
            known_outputs[output] = 0

        if operation == "XOR" and op1 in known_outputs and op2 in known_outputs:
            known_outputs[output] = known_outputs[op1] ^ known_outputs[op2]

indices = []
for a in known_outputs:
    if a.startswith("z"):
        indices.append(a)

indices = sorted(indices, reverse=True)
print(indices)

print(known_outputs)
s = ""
for a in indices:
    s += str(known_outputs[a])

print(s)

print(int(s, 2))
