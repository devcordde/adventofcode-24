from collections import Counter, defaultdict

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=11)
stones = [int(stone) for stone in lines[0].split(" ")]


def modify_stones(old_stones: dict[int, int]) -> dict[int, int]:
    new_stones = defaultdict(int)

    for stone, count in old_stones.items():
        if stone == 0:
            new_stones[1] += count
        elif len(str(stone)) % 2 == 0:
            left_int = int(str(stone)[:len(str(stone)) // 2])
            right_int = int(str(stone)[len(str(stone)) // 2:])

            new_stones[left_int] += count
            new_stones[right_int] += count
        else:
            new_stones[stone * 2024] += count

    return new_stones


def blink(times: int) -> int:
    modified_stones = Counter(stones)
    for _ in range(times):
        modified_stones = modify_stones(modified_stones)

    return sum(modified_stones.values())


write(f"After blinking <25 times>, there are <{blink(25)}> stones.")
write(f"After blinking <75 times>, there are <{blink(75)}> stones.")
