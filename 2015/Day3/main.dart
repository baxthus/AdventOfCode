import 'dart:collection';
import 'dart:io';

class Pair<T, U> {
  final T first;
  final U second;

  Pair(this.first, this.second);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}

int countHousesWithPresents(String directions) {
  int x = 0, y = 0;
  var visited = HashSet<Pair<int, int>>();
  visited.add(Pair(x, y));

  for (var direction in directions.split('')) {
    switch (direction) {
      case '^':
        y++;
        break;
      case 'v':
        y--;
        break;
      case '>':
        x++;
        break;
      case '<':
        x--;
        break;
    }
    visited.add(Pair(x, y));
  }

  return visited.length;
}

int countHousesWithPresents2(String directions) {
  int santaX = 0, santaY = 0, robotX = 0, robotY = 0;
  var visited = HashSet<Pair<int, int>>();
  visited.add(Pair(0, 0));

  for (int i = 0; i < directions.length; ++i) {
    int x, y;
    if (i % 2 == 0) {
      x = santaX;
      y = santaY;
    } else {
      x = robotX;
      y = robotY;
    }

    switch (directions[i]) {
      case '^':
        y++;
        break;
      case 'v':
        y--;
        break;
      case '>':
        x++;
        break;
      case '<':
        x--;
        break;
    }

    if (i % 2 == 0) {
      santaX = x;
      santaY = y;
    } else {
      robotX = x;
      robotY = y;
    }

    visited.add(Pair(x, y));
  }

  return visited.length;
}

void main() async {
  var file = File('input.txt');
  var directions = await file.readAsString();

  print('Part 1: ${countHousesWithPresents(directions)}');
  print('Part 2: ${countHousesWithPresents2(directions)}');
}
