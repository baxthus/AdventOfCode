import sys


class Display:
    WIDTH = 50
    HEIGHT = 6

    def __init__(self):
        self.screen = [
            [False for _ in range(self.WIDTH)] for _ in range(self.HEIGHT)
        ]

    def rect(self, width: int, height: int):
        for r in range(height):
            for c in range(width):
                if 0 <= r < self.HEIGHT and 0 <= c < self.WIDTH:
                    self.screen[r][c] = True

    def rotate_row(self, row_idx: int, amount: int):
        if not (0 <= row_idx < self.HEIGHT):
            return

        row = self.screen[row_idx]
        effective_amount = amount % self.WIDTH
        self.screen[row_idx] = row[-effective_amount:] + row[:-effective_amount]

    def rotate_column(self, col_idx: int, amount: int):
        if not (0 <= col_idx < self.WIDTH):
            return

        column_values = [self.screen[r][col_idx] for r in range(self.HEIGHT)]

        effective_amount = amount % self.HEIGHT
        rotated_column = column_values[-effective_amount:] + column_values[:-effective_amount]

        for r in range(self.HEIGHT):
            self.screen[r][col_idx] = rotated_column[r]

    def count_lit_pixels(self) -> int:
        return sum(pixel for row in self.screen for pixel in row)

    def print_screen(self):
        for row in self.screen:
            print(''.join(['#' if pixel else '.' for pixel in row]))

if __name__ == '__main__':
    display = Display()

    for line in sys.stdin:
        parts = line.strip().split()
        command = parts[0]

        if command == 'rect':
            if len(parts) > 1:
                dimensions = parts[1].split('x')
                if len(dimensions) == 2:
                    width = int(dimensions[0])
                    height = int(dimensions[1])
                    display.rect(width, height)
        elif command == 'rotate':
            if len(parts) >= 5:
                op_type = parts[1]
                index_str = parts[2].split('=')[1]
                index = int(index_str)
                amount = int(parts[4])

                if op_type == 'row':
                    display.rotate_row(index, amount)
                elif op_type == 'column':
                    display.rotate_column(index, amount)

    print(f'Number of lit pixels: {display.count_lit_pixels()}')
    print('Final screen:')
    display.print_screen()
