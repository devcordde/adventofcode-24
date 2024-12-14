from typing import Tuple, List

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

GRID_WIDTH = 101
HALF_GRID_WIDTH = GRID_WIDTH // 2
GRID_HEIGHT = 103
HALF_GRID_HEIGHT = GRID_HEIGHT // 2

lines = read_plain_input(day=14)

robots = []
for i, line in enumerate(lines):
    p_x = int(line.split(" ")[0].replace("p=", "").split(",")[0])
    p_y = int(line.split(" ")[0].replace("p=", "").split(",")[1])
    v_x = int(line.split(" ")[1].replace("v=", "").split(",")[0])
    v_y = int(line.split(" ")[1].replace("v=", "").split(",")[1])

    robots.append([(p_x, p_y), (v_x, v_y)])


def simulate(p: Tuple[int, int], v: Tuple[int, int], seconds: int) -> Tuple[int, int]:
    return (p[0] + seconds * v[0]) % GRID_WIDTH, (p[1] + seconds * v[1]) % GRID_HEIGHT


# Part 1
def count_positions(moved_positions: List[Tuple[int, int]], x_pred, y_pred) -> int:
    return len([p for p in moved_positions if x_pred(p[0]) and y_pred(p[1])])


positions = [simulate(p, v, 100) for p, v in robots]

upper_left = count_positions(positions, lambda x: x < HALF_GRID_WIDTH, lambda y: y < HALF_GRID_HEIGHT)
upper_right = count_positions(positions, lambda x: HALF_GRID_WIDTH < x, lambda y: y < HALF_GRID_HEIGHT)
lower_left = count_positions(positions, lambda x: x < HALF_GRID_WIDTH, lambda y: HALF_GRID_HEIGHT < y)
lower_right = count_positions(positions, lambda x: HALF_GRID_WIDTH < x, lambda y: HALF_GRID_HEIGHT < y)

write(f"The safety factor after 100 seconds is <{upper_left * upper_right * lower_left * lower_right}>.")


# Part 2
def find_timestamp_with_consecutive_robots(robots: List[List[Tuple[int, int]]], consecutive_robots: int) -> int:
    fulfilled = -1

    for elapsed in range(GRID_WIDTH * GRID_HEIGHT):
        for i in range(len(robots)):
            p, v = robots[i]

            robots[i] = [simulate(p, v, 1), v]

        # Build grid
        grid = [["." for _ in range(GRID_HEIGHT)] for _ in range(GRID_HEIGHT)]

        for pos, _ in robots:
            grid[pos[0]][pos[1]] = "*"

        for i in range(len(grid)):
            x = "".join(grid[i])
            if consecutive_robots * "*" in x:
                if fulfilled != -1:
                    return -1

                fulfilled = elapsed
                break

    return fulfilled + 1


write(f"After <{find_timestamp_with_consecutive_robots(robots, 14)}> seconds, the easter egg is shown.")
