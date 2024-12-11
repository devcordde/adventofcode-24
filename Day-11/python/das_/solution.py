from collections import defaultdict

def solve(stones, blinks):
    for _ in range(blinks):
        new_stones = defaultdict(int)

        for stone, amount in stones.items():
            if stone == 0:
                new_stones[1] += amount
            elif len(s := str(stone)) % 2 == 0:
                new_stones[int(s[:len(s) // 2])] += amount
                new_stones[int(s[len(s) // 2:])] += amount
            else:
                new_stones[stone * 2024] += amount

        stones = new_stones

    return sum(stones.values())

numbers = list(map(int, open("input.txt").read().split()))
initial_stones = {element: numbers.count(element) for element in set(numbers)}
print("Part 1:", solve(initial_stones, 25))
print("Part 2:", solve(initial_stones, 75))
