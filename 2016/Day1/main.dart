import 'dart:collection';
import 'dart:io';

enum Direction { North, East, South, West }

class Position {
  int x;
  int y;

  Position(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

Future<List<String>> readFile(String filename) async {
  final file = File(filename);
  final line = await file.readAsString();
  final instructions = line
      .split(',')
      .map((instr) => instr.trim())
      .where((instr) => instr.isNotEmpty)
      .toList();
  return instructions;
}

void main() async {
  final instructions = await readFile('input.txt');

  var pos = Position(0, 0);
  var dir = Direction.North;
  var visited = HashSet<Position>();
  visited.add(pos);
  var found = false;
  var firstRevisitedDistance = 0;

  for (var instr in instructions) {
    var turn = instr[0];
    var steps = int.parse(instr.substring(1));

    if (turn == 'L') {
      dir = Direction.values[(dir.index + 3) % 4]; // Left
    } else if (turn == 'R') {
      dir = Direction.values[(dir.index + 1) % 4]; // Right
    }

    for (var i = 0; i < steps; ++i) {
      switch (dir) {
        case Direction.North:
          pos = Position(pos.x, pos.y + 1);
          break;
        case Direction.East:
          pos = Position(pos.x + 1, pos.y);
          break;
        case Direction.South:
          pos = Position(pos.x, pos.y - 1);
          break;
        case Direction.West:
          pos = Position(pos.x - 1, pos.y);
          break;
      }

      if (visited.contains(pos) && !found) {
        firstRevisitedDistance = pos.x.abs() + pos.y.abs();
        found = true;
      }
      visited.add(pos);
    }
  }

  print('Part 1: ${pos.x.abs() + pos.y.abs()}');
  if (found)
    print('Part 2: $firstRevisitedDistance');
  else
    print('Part 2: Not found');
}
