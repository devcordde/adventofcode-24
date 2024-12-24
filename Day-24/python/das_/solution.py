import re

def calc(gates, values):
    all_letters = set(values.keys()).union(set(gates.keys()))
    while len(values) != len(all_letters):
        for result, gate in gates.items():
            if gate[0][0] in values and gate[0][1] in values:
                values[result] = op(gate[1], values[gate[0][0]], values[gate[0][1]])
    return gate_to_num(values, "z")

def op(op, a, b):
    if op == "AND":
        return a & b
    elif op == "OR":
        return a | b
    elif op == "XOR":
        return a ^ b

def gate_to_num(v, d):
    return int("".join(map(lambda x: str(x[1]), sorted(filter(lambda x: x[0].startswith(d), v.items()), reverse=True))), 2)

lines = open("input.txt").read().split("\n\n")
values = dict(map(lambda x: (x[0], int(x[1])), [line.split(": ") for line in lines[0].splitlines()]))
gates = dict(map(lambda x: (x[3], ((x[0], x[2]), x[1])), [re.findall(r"(.{3}) (AND|OR|XOR) (.{3}) -> (.{3})", line)[0] for line in lines[1].splitlines()]))

print("Part 1:", calc(gates, values))
