def process_lights(instructions):
    grid = [[False] * 1000 for _ in range(1000)]

    for instruction in instructions:
        parts = instruction.split()
        if parts[0] == 'turn':
            action = parts[1]
            start = tuple(map(int, parts[2].split(',')))
            end = tuple(map(int, parts[4].split(',')))
            for i in range(start[0], end[0] + 1):
                for j in range(start[1], end[1] + 1):
                    grid[i][j] = (action == 'on')
        elif parts[0] == 'toggle':
            start = tuple(map(int, parts[1].split(',')))
            end = tuple(map(int, parts[3].split(',')))
            for i in range(start[0], end[0] + 1):
                for j in range(start[1], end[1] + 1):
                    grid[i][j] = not grid[i][j]
    
    return sum(sum(row) for row in grid)


def process_lights_brightness(instructions):
    grid = [[0] * 1000 for _ in range(1000)]

    for instruction in instructions:
        parts = instruction.split()
        if parts[0] == 'turn':
            action = parts[1]
            start = tuple(map(int, parts[2].split(',')))
            end = tuple(map(int, parts[4].split(',')))
            for i in range(start[0], end[0] + 1):
                for j in range(start[1], end[1] + 1):
                    if action == 'on':
                        grid[i][j] += 1
                    elif action == 'off':
                        grid[i][j] = max(0, grid[i][j] - 1)
        elif parts[0] == 'toggle':
            start = tuple(map(int, parts[1].split(',')))
            end = tuple(map(int, parts[3].split(',')))
            for i in range(start[0], end[0] + 1):
                for j in range(start[1], end[1] + 1):
                    grid[i][j] += 2
        
    return sum(sum(row) for row in grid)

with open('input.txt', 'r') as file:
    instructions = file.read().splitlines()

print(f"Part 1: {process_lights(instructions)}")
print(f"Part 2: {process_lights_brightness(instructions)}")