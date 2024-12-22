from typing import Tuple, List, Dict

from tqdm import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=22)
initial_secrets = [int(line) for line in lines]


def mix(secret: int, given_value: int) -> int:
    return secret ^ given_value


def prune(secret: int) -> int:
    return secret % 16777216


def next_secret(secret: int) -> int:
    intermediate = prune(mix(secret, secret << 6))
    intermediate = prune(mix(intermediate, intermediate >> 5))
    intermediate = prune(mix(intermediate, intermediate << 11))

    return intermediate


def compute_secrets(init_secret: int) -> List[int]:
    secrets = [init_secret]

    current_secret = init_secret
    for _ in range(2000):
        current_secret = next_secret(current_secret)
        secrets.append(current_secret)

    return secrets


def last_digit(val: int) -> int:
    return val % 10


def prepare_changes_and_bananas(sequence: List[int]) -> Dict[Tuple, int]:
    diff_sequence = []

    for i in range(len(sequence) - 1):
        diff_sequence.append(last_digit(sequence[i + 1]) - last_digit(sequence[i]))

    bananas = dict()
    for i in range(len(diff_sequence) - 4):
        if tuple(diff_sequence[i:i + 4]) in bananas:
            continue

        bananas[tuple(diff_sequence[i:i + 4])] = last_digit(sequence[i + 4])

    return bananas


changes_and_bananas = []
monkey_instructions = set()
secrets_sum = 0

for initial_secret in tqdm(initial_secrets):
    sequence = compute_secrets(initial_secret)
    changes_and_bananas.append(prepare_changes_and_bananas(sequence))

    monkey_instructions.update(changes_and_bananas[-1].keys())

    secrets_sum += sequence[-1]

write(f"The sum of all generated secrets is <{secrets_sum}>.")

total_bananas = -1
for monkey_diff in tqdm(monkey_instructions):
    bananas = 0

    for i in range(len(changes_and_bananas)):
        if monkey_diff in changes_and_bananas[i]:
            bananas += changes_and_bananas[i][monkey_diff]

    if bananas > total_bananas:
        total_bananas = bananas

write(f"In total, I can get <{total_bananas}> bananas.")
