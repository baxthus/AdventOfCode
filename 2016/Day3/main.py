import sys


def is_valid_triangle(a: int, b: int, c: int) -> bool:
    return (a + b > c) and (a + c > b) and (b + c > a)

def parse_input(lines: list[str]) -> list[list[int]]:
    triangles: list[list[int]] = []
    for line in lines:
        parts = line.split()
        if len(parts) == 3:
            sides = [int(parts[0]), int(parts[1]), int(parts[2])]
            triangles.append(sides)
    return triangles

def count_valid_triangles_row(data: list[list[int]]) -> int:
    count = 0
    for sides in data:
        if is_valid_triangle(sides[0], sides[1], sides[2]):
            count += 1
    return count

def count_valid_triangles_column(data: list[list[int]]) -> int:
    count = 0
    num_rows = len(data)

    if num_rows == 0:
        return 0

    for col_idx in range(3):
        for row_start_idx in range(0, num_rows, 3):
            if row_start_idx + 2 < num_rows:
                a = data[row_start_idx][col_idx]
                b = data[row_start_idx + 1][col_idx]
                c = data[row_start_idx + 2][col_idx]
                if is_valid_triangle(a, b, c):
                    count += 1

    return count

if __name__ == '__main__':
    input_lines = [line.strip() for line in sys.stdin if line.strip()]
    if not input_lines:
        raise ValueError("No input provided")

    data = parse_input(input_lines)
    if not data:
        raise ValueError("No valid triangle data found")

    print(f'Part 1: {count_valid_triangles_row(data)}')
    print(f'Part 1: {count_valid_triangles_column(data)}')
