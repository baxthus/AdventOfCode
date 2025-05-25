import hashlib
from collections import deque
from typing import List, Tuple

def md5(input: str) -> str:
    return hashlib.md5(input.encode()).hexdigest()

def get_open_doors(hash: str) -> List[bool]:
    doors = [False] * 4
    for i in range(4):
        if 'b' <= hash[i] <= 'f':
            doors[i] = True
    return doors

def find_paths(passcode: str) -> Tuple[str, int]:
    q: deque[Tuple[int, int, str]] = deque()
    q.append((0, 0, ''))

    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)] # U, D, L, R
    dir_chars = ['U', 'D', 'L', 'R']

    shortest_path = ''
    longest_path_length = 0

    while q:
        row, col, path = q.popleft()

        if row == 3 and col == 3:
            if not shortest_path:
                shortest_path = path
            if len(path) > longest_path_length:
                longest_path_length = len(path)
            continue

        current_hash = md5(passcode + path)
        open_doors = get_open_doors(current_hash)

        for i in range(4):
            if open_doors[i]:
                new_row = row + directions[i][0]
                new_col = col + directions[i][1]
                if 0 <= new_row < 4 and 0 <= new_col < 4:
                    q.append((new_row, new_col, path + dir_chars[i]))

    return shortest_path, longest_path_length

if __name__ == "__main__":
    passcode = 'qtetzkpl'
    shortest, longest_len = find_paths(passcode)
    print(f"Shortest path: {shortest}")
    print(f"Longest path length: {longest_len}")
