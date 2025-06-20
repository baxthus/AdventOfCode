import sys

def is_safe(levels: list[int]) -> bool:
    if len(levels) < 2:
        return True

    increasing = levels[1] > levels[0]

    for i in range(1, len(levels)):
        diff = levels[i] - levels[i - 1]
        if increasing and diff <= 0:
            return False
        if not increasing and diff >= 0:
            return False
        if not (1 <= abs(diff) <= 3):
            return False
    return True

def is_safe_with_dampener(levels: list[int]) -> bool:
    if is_safe(levels):
        return True

    for i in range(len(levels)):
        temp_levels = levels[:i] + levels[i+1:]
        if is_safe(temp_levels):
            return True
    return False

safe_count = 0
safe_count_with_dampener = 0

for line in sys.stdin:
    levels = [int(x) for x in line.strip().split()]

    if not levels:
        continue

    if is_safe(levels):
        safe_count += 1
    if is_safe_with_dampener(levels):
        safe_count_with_dampener += 1

print(f'Part 1: {safe_count}')
print(f'Part 2: {safe_count_with_dampener}')
