from tqdm import tqdm

def mix_prune(n, m):
    return (n ^ m) % 16777216

numbers = [int(a) for a in open("input.txt").read().splitlines()]

part1 = 0
maps = []
for i in tqdm(range(len(numbers))):
    map = dict()
    list_of_seq = set()
    previous = [0, 0, 0, 0]
    number = numbers[i]

    for l in range(2000):
        number = mix_prune(number, number * 64)
        number = mix_prune(number, number // 32)
        number = mix_prune(number, number * 2048)

        tens = number % 10
        diff = tens - previous[3]

        sequence = (previous[0] - previous[1], previous[1] - previous[2], previous[2] - previous[3], previous[3] - tens)
        if sequence not in list_of_seq and l > 3:
            map.setdefault(tens, set()).add(sequence)

        list_of_seq.add(sequence)
        del previous[0]
        previous.append(tens)

    maps.append(map)
    part1 += number

sequences_containing_9 = list(set((i for m in maps for i in m[9])))
part2 = 0

for sequence in tqdm(range(len(sequences_containing_9))):
    sequence = sequences_containing_9[sequence]
    value = 0

    for map in maps:
        for k in map:
            if sequence in map[k]:
                value += k
                break

    part2 = max(part2, value)

print("Part 1:", part1)
print("Part 2:", part2)
