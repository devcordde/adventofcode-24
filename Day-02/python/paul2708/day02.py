from typing import List

from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=2)
reports = [list(map(int, line.split(" "))) for line in lines]


def is_valid_report(report: List[int]):
    increase = report[0] < report[1]

    for i in range(1, len(report)):
        if increase and not (1 <= report[i] - report[i - 1] <= 3):
            return False
        elif not increase and not (1 <= report[i - 1] - report[i] <= 3):
            return False

    return True


def count_valid_reports(reports: List[List[int]]):
    return len(list(filter(is_valid_report, reports)))


# Part 1
write(f"There are <{count_valid_reports(reports)}> valid reports.")


# Part 2
def populate(report: List[int]):
    result = []

    for i in range(len(report)):
        copy = report.copy()
        del copy[i]
        result.append(copy)

    return result


valid_reports = 0

for report in reports:
    if count_valid_reports([report] + populate(report)) > 0:
        valid_reports += 1

write(f"With the use of the Problem Dampener, there are <{valid_reports}> valid reports.")
