from shared.paul2708.input_reader import *
from shared.paul2708.output import write

lines = read_plain_input(day=1)
left_column = [int(line.split("   ")[0]) for line in lines]
right_column = [int(line.split("   ")[1]) for line in lines]

distances = 0
similarity_score = 0

for a, b in zip(sorted(left_column), sorted(right_column)):
    distances += abs(a - b)
    similarity_score += a * right_column.count(a)

write(f"The total sum of distances is <{distances}>.")
write(f"The total similarity score is <{similarity_score}>.")
