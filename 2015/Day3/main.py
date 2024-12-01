def count_houses_with_presents(directions):
    x, y = 0, 0
    visited = set([(x, y)])

    for direction in directions:
        if direction == '^':
            y += 1
        elif direction == 'v':
            y -= 1
        elif direction == '>':
            x += 1
        elif direction == '<':
            x -= 1

        visited.add((x, y))
    
    return len(visited)

def count_houses_with_presents2(directions):
    santa_x, santa_y = 0, 0
    robot_x, robot_y = 0, 0
    visited = set([(0, 0)])

    for i, direction in enumerate(directions):
        if i % 2 == 0:
            if direction == '^':
                santa_y += 1
            elif direction == 'v':
                santa_y -= 1
            elif direction == '>':
                santa_x += 1
            elif direction == '<':
                santa_x -= 1
            visited.add((santa_x, santa_y))
        else:
            if direction == '^':
                robot_y += 1
            elif direction == 'v':
                robot_y -= 1
            elif direction == '>':
                robot_x += 1
            elif direction == '<':
                robot_x -= 1
            visited.add((robot_x, robot_y))
    
    return len(visited)

with open('input.txt') as f:
    directions = f.read().strip()

print(f"Part 1: {count_houses_with_presents(directions)}")
print(f"Part 2: {count_houses_with_presents2(directions)}")