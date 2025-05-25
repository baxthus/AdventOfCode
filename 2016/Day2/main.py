import sys

if __name__ == '__main__':
    instructions = [line.strip() for line in sys.stdin if line.strip()]

    r1, c1 = 1, 1
    code_parts: list[str] = []

    for line in instructions:
        for move in line:
            if move == 'U':
                r1 = max(0, r1 - 1)
            elif move == 'D':
                r1 = min(2, r1 + 1)
            elif move == 'L':
                c1 = max(0, c1 - 1)
            elif move == 'R':
                c1 = min(2, c1 + 1)

        digit = r1 * 3 + c1 + 1
        code_parts.append(str(digit))

    code = ''.join(code_parts)
    print(f'Part1 1: {code}')

    keypad_layout = {
        (0, 2): '1',
        (1, 1): '2',
        (1, 2): '3',
        (1, 3): '4',
        (2, 0): '5',
        (2, 1): '6',
        (2, 2): '7',
        (2, 3): '8',
        (2, 4): '9',
        (3, 1): 'A',
        (3, 2): 'B',
        (3, 3): 'C',
        (4, 2): 'D'
    }

    r2, c2 = 2, 0
    code_parts: list[str] = []

    for line in instructions:
        for move in line:
            dr, dc = 0, 0
            if move == 'U':
                dr = -1
            elif move == 'D':
                dr = 1
            elif move == 'L':
                dc = -1
            elif move == 'R':
                dc = 1

            new_r2, new_c2 = r2 + dr, c2 + dc

            if (new_r2, new_c2) in keypad_layout:
                r2, c2 = new_r2, new_c2

        code_parts.append(keypad_layout[(r2, c2)])

    code = ''.join(code_parts)
    print(f'Part2 2: {code}')
