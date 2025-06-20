import re
import sys

def solve1(input: str) -> int:
    total = 0

    pattern = re.compile(r'mul\((\d{1,3}),(\d{1,3})\)')

    for match in pattern.finditer(input):
        x = int(match.group(1))
        y = int(match.group(2))
        total += x * y

    return total

def solve2(input: str) -> int:
    total = 0
    enabled = True

    pattern = re.compile(r"(do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\))")

    for match in pattern.finditer(input):
        instruction = match.group(1)

        if instruction == 'do()':
            enabled = True
        elif instruction == "don't()":
            enabled = False
        elif enabled and instruction.startswith('mul'):
            x = int(match.group(2))
            y = int(match.group(3))
            total += x * y

    return total

data = sys.stdin.read()

print(f'Part 1: {solve1(data)}')
print(f'Part 2: {solve2(data)}')
