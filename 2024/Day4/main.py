def count_xmas(grid):
    rows, cols = len(grid), len(grid[0])
    count = 0
    directions = [
        (0, 1), (1, 0), (1, 1), (-1, 1),
        (0, -1), (-1, 0), (-1, -1), (1, -1)
    ]

    def check_xmas(r, c, dr, dc):
        if (0 <= r < rows and 0 <= c < cols and
            0 <= r+3*dr < rows and 0 <= c+3*dc < cols):
            return (grid[r][c] == 'X' and
                    grid[r+dr][c+dc] == 'M' and
                    grid[r+2*dr][c+2*dc] == 'A' and
                    grid[r+3*dr][c+3*dc] == 'S')
        return False

    for r in range(rows):
        for c in range(cols):
            for dr, dc in directions:
                if check_xmas(r, c, dr, dc):
                    count += 1

    return count

def count_xmas2(grid):
    rows, cols = len(grid), len(grid[0])
    count = 0

    def check_xmas(r, c):
        if (r-1 < 0 or r+1 >= rows or c-1 < 0 or c+1 >= cols):
            return False
        center = grid[r][c]
        if center != 'A':
            return False
        corners = [
            grid[r-1][c-1], grid[r-1][c+1],
            grid[r+1][c-1], grid[r+1][c+1]
        ]
        return (corners.count('M') == 2 and
                corners.count('S') == 1 and
                ((corners[0] == 'M' and corners[3] == 'M') or
                 (corners[1] == 'M' and corners[2] == 'M')))

    for r in range(rows-1):
        for c in range(cols-1):
            if check_xmas(r, c):
                count += 1

    return count

with open('input.txt', 'r') as file:
    grid = [list(line.strip()) for line in file]

print(f"Part 1: {count_xmas(grid)}")
print(f"Part 2: {count_xmas2(grid)}")
