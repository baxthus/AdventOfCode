from dataclasses import dataclass
from enum import Enum
import sys


class Direction(Enum):
    NORTH = 0
    EAST = 1
    SOUTH = 2
    WEST = 3

@dataclass(frozen=True)
class Position:
    x: int
    y: int

if __name__ == "__main__":
    line = sys.stdin.readline().strip()
    instructions = [instr.strip() for instr in line.split(',')]

    pos = Position(0, 0)
    current_dir_val = Direction.NORTH.value
    visited = {pos}
    found_revisited = False
    first_revisited_distance = 0

    for instr in instructions:
        turn = instr[0]
        steps = int(instr[1:])

        if turn == 'L':
            current_dir_val = (current_dir_val + 3) % 4
        elif turn == 'R':
            current_dir_val = (current_dir_val + 1) % 4

        current_dir = Direction(current_dir_val)

        for _ in range(steps):
            x, y = pos.x, pos.y
            if current_dir == Direction.NORTH:
                y += 1
            elif current_dir == Direction.EAST:
                x += 1
            elif current_dir == Direction.SOUTH:
                y -= 1
            elif current_dir == Direction.WEST:
                x -= 1

            pos = Position(x, y)

            if pos in visited and not found_revisited:
                first_revisited_distance = abs(pos.x) + abs(pos.y)
                found_revisited = True
            visited.add(pos)

    final_distance = abs(pos.x) + abs(pos.y)
    print(f'Part 1: {final_distance}')

    if found_revisited:
        print(f'Part 2: {first_revisited_distance}')
