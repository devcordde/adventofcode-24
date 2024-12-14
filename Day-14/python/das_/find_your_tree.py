import re

def tuple_add_mod(a, b):
    return (a[0] + b[0]) % 101, (a[1] + b[1]) % 103

def display_map(r):
    r = list(map(lambda d: d[0], r))
    for u in range(103):
        for i in range(101):
            if (i, u) in r:
                print(r.count((i, u)), end="")
            else:
                print(".", end="")
        print()

lines = [re.findall(r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)", line)[0] for line in open("input.txt")]
robots = list(map(lambda v: ((int(v[0]), int(v[1])), (int(v[2]), int(v[3]))), lines))

print("Find your own christmas tree!")
start = int(input("Please input the number to start at: "))
for second in range(100_000):
    for k, robot in enumerate(robots):
        robots[k] = (tuple_add_mod(robot[0], robot[1]), robot[1])

    if second < start:
        continue

    display_map(robots)
    print(f"Second: {second + 1}", end="")

    coordinates = list(map(lambda d: d[0], robots))
    print(f" (POTENTIAL CHRISTMAS TREE!!!)" if len(coordinates) == len(set(coordinates)) else "")

    print("Press enter to continue, \"stop\" to stop execution")
    if input() == "stop":
        break
