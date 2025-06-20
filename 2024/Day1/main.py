from collections import Counter
import sys

left: list[int] = []
right: list[int] = []

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    parts = line.split()
    if len(parts) == 2:
        left.append(int(parts[0]))
        right.append(int(parts[1]))

left.sort()
right.sort()

total_distance = 0
for i in range(len(left)):
    total_distance += abs(left[i] - right[i])

print(f'Part 1: {total_distance}')

right_counts = Counter(right)
similatiry_score = 0
for num_in_left in left:
    similatiry_score += num_in_left * right_counts[num_in_left]

print(f'Part 2: {similatiry_score}')
