def read_input(filepath):
    with open(filepath, 'r') as file:
        return [list(line.strip()) for line in file]

def count_on_neighbors(grid, x, y):
    count = 0
    for dx in [-1, 0, 1]:
        for dy in [-1, 0, 1]:
            if dx == 0 and dy == 0:
                continue
            nx, ny = x + dx, y + dy
            if 0 <= nx < len(grid) and 0 <= ny < len(grid[0]):
                count += grid[nx][ny] == '#'
    return count

def step(grid, corners=False):
    new_grid = [row[:] for row in grid]
    for x in range(len(grid)):
        for y in range(len(grid[0])):
            on_neighbors = count_on_neighbors(grid, x, y)
            if grid[x][y] == '#':
                new_grid[x][y] = '#' if on_neighbors in [2, 3] else '.'
            else:
                new_grid[x][y] = '#' if on_neighbors == 3 else '.'
    
    if corners:
        new_grid[0][0] = new_grid[0][-1] = new_grid[-1][0] = new_grid[-1][-1] = '#'

    return new_grid

def count_on_lights(grid):
    return sum(row.count('#') for row in grid)

grid = read_input('input.txt')
for _ in range(100):
    grid = step(grid)

grid2 = read_input('input.txt')
grid[0][0] = grid[0][-1] = grid[-1][0] = grid[-1][-1] = '#'
for _ in range(100):
    grid2 = step(grid2, corners=True)

print(f'Part 1: {count_on_lights(grid)}')
print(f'Part 2: {count_on_lights(grid2)}')