import 'dart:collection';
import 'dart:io';

class Node {
  final int x, y;
  final int size, used, avail;

  Node(this.x, this.y, this.size, this.used, this.avail);
}

class State {
  final int emptyX, emptyY;
  final int goalX, goalY;
  final int steps;

  State(this.emptyX, this.emptyY, this.goalX, this.goalY, this.steps);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is State &&
        emptyX == other.emptyX &&
        emptyY == other.emptyY &&
        goalX == other.goalX &&
        goalY == other.goalY;
  }

  @override
  int get hashCode => Object.hash(emptyX, emptyY, goalX, goalY);
}

void printGrid(
  List<Node> nodes,
  int maxX,
  int maxY,
  int emptyX,
  int emptyY,
  int goalX,
) {
  final grid = List.generate(maxY + 1, (_) => List.filled(maxX + 1, '.'));

  for (final node in nodes) {
    if (node.used > 100) grid[node.y][node.x] = '#';
  }

  grid[emptyY][emptyX] = '_';
  grid[0][0] = 'O';
  grid[0][goalX] = 'G';

  print('Grid visualization:');
  for (int y = 0; y <= maxY; y++) {
    print(grid[y].join(' '));
  }
}

int solvePart2(List<Node> nodes) {
  int maxX = 0, maxY = 0;
  for (final node in nodes) {
    maxX = maxX > node.x ? maxX : node.x;
    maxY = maxY > node.y ? maxY : node.y;
  }

  int emptyX = -1, emptyY = -1;
  for (final node in nodes) {
    if (node.used == 0) {
      emptyX = node.x;
      emptyY = node.y;
      break;
    }
  }

  int goalX = maxX;
  int goalY = 0;

  final viableNodes = List.generate(
    maxY + 1,
    (_) => List.filled(maxX + 1, true),
  );

  for (final node in nodes) {
    if (node.used > 100) viableNodes[node.y][node.x] = false;
  }

  printGrid(nodes, maxX, maxY, emptyX, emptyY, goalX);

  final q = Queue<State>();
  final visited = <State>{};

  final start = State(emptyX, emptyY, goalX, goalY, 0);
  q.add(start);
  visited.add(start);

  const dx = [0, 1, 0, -1];
  const dy = [-1, 0, 1, 0];

  while (q.isNotEmpty) {
    final current = q.removeFirst();

    if (current.goalX == 0 && current.goalY == 0) return current.steps;

    for (int dir = 0; dir < 4; dir++) {
      final newEmptyX = current.emptyX + dx[dir];
      final newEmptyY = current.emptyY + dy[dir];

      if (newEmptyX >= 0 &&
          newEmptyX <= maxX &&
          newEmptyY >= 0 &&
          newEmptyY <= maxY &&
          viableNodes[newEmptyY][newEmptyX]) {
        int newGoalX = current.goalX;
        int newGoalY = current.goalY;

        if (newEmptyX == current.goalX && newEmptyY == current.goalY) {
          newGoalX = current.emptyX;
          newGoalY = current.emptyY;
        }

        final newState = State(
          newEmptyX,
          newEmptyY,
          newGoalX,
          newGoalY,
          current.steps + 1,
        );

        if (!visited.contains(newState)) {
          visited.add(newState);
          q.add(newState);
        }
      }
    }
  }

  return -1;
}

void main() {
  final nodes = <Node>[];

  // Skip the first two lines of input
  stdin.readLineSync();
  stdin.readByteSync();

  final pattern = RegExp(
    r'node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+\d+%',
  );

  String? line;
  while ((line = stdin.readLineSync()) != null && line!.isNotEmpty) {
    final match = pattern.firstMatch(line);
    if (match != null) {
      final x = int.parse(match.group(1)!);
      final y = int.parse(match.group(2)!);
      final size = int.parse(match.group(3)!);
      final used = int.parse(match.group(4)!);
      final avail = int.parse(match.group(5)!);

      nodes.add(Node(x, y, size, used, avail));
    }
  }

  int viablePairs = 0;
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes.length; j++) {
      if (i != j && nodes[i].used > 0 && nodes[i].used <= nodes[j].avail) {
        viablePairs++;
      }
    }
  }

  print('Number of viable pairs: $viablePairs');

  final minSteps = solvePart2(nodes);
  print('Minium steps required: $minSteps');
}
