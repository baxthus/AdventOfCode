from collections import deque
import sys

def scramble(password: list[str], instruction: str) -> list[str]:
    parts = instruction.split()
    p = list(password)

    if parts[0] == 'swap':
        if parts[1] == 'position':
            pos1, pos2 = int(parts[2]), int(parts[5])
            p[pos1], p[pos2] = p[pos2], p[pos1]
        elif parts[1] == 'letter':
            let1, let2 = parts[2], parts[5]
            pos1, pos2 = p.index(let1), p.index(let2)
            p[pos1], p[pos2] = p[pos2], p[pos1]
    elif parts[0] == 'rotate':
        d = deque(p)
        if parts[1] == 'left':
            steps = int(parts[2])
            d.rotate(-steps)
        elif parts[1] == 'right':
            steps = int(parts[2])
            d.rotate(steps)
        elif parts[1] == 'based':
            letter = parts[6]
            idx = p.index(letter)
            rotations = 1 + idx
            if idx >= 4:
                rotations += 1
            d.rotate(rotations)
        p = list(d)
    elif parts[0] == 'reverse':
        pos1, pos2 = int(parts[2]), int(parts[4])
        sub = p[pos1:pos2 + 1]
        sub.reverse()
        p[pos1:pos2 + 1] = sub
    elif parts[0] == 'move':
        pos1, pos2 = int(parts[2]), int(parts[5])
        letter = p.pop(pos1)
        p.insert(pos2, letter)
    
    return p

def unscramble(password: list[str], instruction: str) -> list[str]:
    parts = instruction.split()
    p = list(password)

    if parts[0] == 'swap':
        return scramble(p, instruction)
    elif parts[0] == 'rotate':
        d = deque(p)
        if parts[1] == 'left':
            steps = int(parts[2])
            d.rotate(steps)
        elif parts[1] == 'right':
            steps = int(parts[2])
            d.rotate(-steps)
        elif parts[1] == 'based':
            original_state = list(p)
            temp_deque = deque(p)
            for _ in range(len(p)):
                temp_deque.rotate(-1)
                temp_passport = list(temp_deque)
                if scramble(list(temp_passport), instruction) == original_state:
                    return temp_passport
            return p
        p = list(d)
    elif parts[0] == 'reverse':
        return scramble(p, instruction)
    elif parts[0] == 'move':
        pos1, pos2 = int(parts[2]), int(parts[5])
        letter = p.pop(pos2)
        p.insert(pos1, letter)

    return p

if __name__ == '__main__':
    instructions = [line.strip() for line in sys.stdin if line.strip()]

    password1 = list('abcdefgh')
    for instruction in instructions:
        password1 = scramble(password1, instruction)
    print (f'Part 1: {"".join(password1)}')

    password2 = list('fbgdceah')
    for instruction in reversed(instructions):
        password2 = unscramble(password2, instruction)
    print (f'Part 2: {"".join(password2)}')