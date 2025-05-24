from typing import Optional
import collections


FAVORITE_NUMBER = 1364

def is_wall(x: int, y: int) -> bool:
  if x < 0 or y < 0:
    return True
  formula = x*x + 3*x + 2*x*y + y + y*y + FAVORITE_NUMBER
  bit_count = bin(formula).count('1')
  return bit_count % 2 != 0

def bfs(start_x: int, start_y: int, target_x: int, target_y: int, max_steps: Optional[int] = None) -> int:
  queue = collections.deque([(start_x, start_y, 0)])
  visited = {(start_x, start_y)}

  while queue:
    x, y, steps = queue.popleft()

    if max_steps is None and x == target_x and y == target_y:
      return steps

    if max_steps is not None and steps >= max_steps:
      continue

    directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]

    for dx, dy in directions:
      new_x, new_y = x + dx, y + dy

      if new_x >= 0 and new_y >= 0 and not is_wall(new_x, new_y) and (new_x, new_y) not in visited:
        visited.add((new_x, new_y))
        queue.append((new_x, new_y, steps + 1))

  if max_steps is not None:
    return len(visited)

  return -1

def main() -> None:
  start_x, start_y = 1, 1
  target_x, target_y = 31, 39

  part1 = bfs(start_x, start_y, target_x, target_y)
  print(f"Part 1: {part1}")

  part2 = bfs(start_x, start_y, target_x, target_y, max_steps=50)
  print(f"Part 2: {part2}")

if __name__ == "__main__":
  main()
