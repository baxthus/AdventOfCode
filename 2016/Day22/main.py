from dataclasses import dataclass
from queue import Queue
import re
import sys

@dataclass(frozen=True)
class Node:
    x: int
    y: int
    size: int
    used: int
    avail: int

@dataclass(frozen=True)
class State:
    empty_x: int
    empty_y: int
    goal_x: int
    goal_y: int
    steps: int

def print_grid(nodes: list[Node], max_x: int, max_y: int, empty_x: int, empty_y: int, goal_x: int):
    grid = [['.' for _ in range(max_x + 1)] for _ in range(max_y + 1)]

    for node in nodes:
        if node.used > 100:
            grid[node.y][node.x] = '#'
    
    grid[empty_y][empty_x] = '_'
    grid[0][0] = 'O'
    grid[0][goal_x] = 'G'

    print('Grid visualization:')
    for y in range(max_y + 1):
        print(' '.join(grid[y]))
    
def solve_part2(nodes: list[Node]) -> int:
    max_x = max(node.x for node in nodes)
    max_y = max(node.y for node in nodes)

    empty_x, empty_y = -1, -1
    for node in nodes:
        if node.used == 0:
            empty_x, empty_y = node.x, node.y
            break
    
    goal_x, goal_y = max_x, 0

    viable_nodes = [[True for _ in range(max_x + 1)] for _ in range(max_y + 1)]
    for node in nodes:
        if node.used > 100:
            viable_nodes[node.y][node.x] = False
    
    print_grid(nodes, max_x, max_y, empty_x, empty_y, goal_x)

    q: Queue[State] = Queue()
    visited: set[State] = set()

    start = State(empty_x, empty_y, goal_x, goal_y, 0)
    q.put(start)
    visited.add(start)

    dx = [0, 1, 0, -1]
    dy = [-1, 0, 1, 0]

    while not q.empty():
        current = q.get()

        if current.goal_x == 0 and current.goal_y == 0:
            return current.steps
        
        for direction in range(4):
            new_empty_x = current.empty_x + dx[direction]
            new_empty_y = current.empty_y + dy[direction]

            if (
                0 <= new_empty_x <= max_x and
                0 <= new_empty_y <= max_y and
                viable_nodes[new_empty_y][new_empty_x]
            ):
                new_goal_x, new_goal_y = current.goal_x, current.goal_y

                if new_empty_x == current.goal_x and new_empty_y == current.goal_y:
                    new_goal_x, new_goal_y = current.empty_x, current.empty_y

                new_state = State(new_empty_x, new_empty_y, new_goal_x, new_goal_y, current.steps + 1)

                if new_state not in visited:
                    visited.add(new_state)
                    q.put(new_state)

    return -1

nodes: list[Node] = []

# Skip the first two lines
input()
input()

pattern = r'node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+\d+%'

for line in sys.stdin:
    matches = re.search(pattern, line)
    if matches:
        x = int(matches.group(1))
        y = int(matches.group(2))
        size = int(matches.group(3))
        used = int(matches.group(4))
        avail = int(matches.group(5))

        nodes.append(Node(x, y, size, used, avail))
    
viable_pairs = 0
for i in range(len(nodes)):
    for j in range(len(nodes)):
        if i != j and nodes[i].used > 0 and nodes[i].used <= nodes[j].avail:
            viable_pairs += 1

print(f'Number of viable pairs: {viable_pairs}')

min_steps = solve_part2(nodes)
print(f'Minimum steps required: {min_steps}')