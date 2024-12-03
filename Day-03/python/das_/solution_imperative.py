import re

enabled, counters = True, [0, 0]

for m in re.findall(r"(do\(\))|(don't\(\))|mul\((\d{1,3}),(\d{1,3})\)", open("input.txt").read()):
        enabled = m[0] == "do()" or (enabled and not m[1])
        counters[enabled] += int(m[2]) * int(m[3]) if m[2] else 0

print(sum(counters), counters[1])
