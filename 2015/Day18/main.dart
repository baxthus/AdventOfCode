import 'dart:io';

typedef Grid = List<List<String>>;

Future<Grid> readInput(String filepath) async {
  final lines = await File(filepath).readAsLines();
  return lines.map((line) => line.split('')).toList();
}

int countOnNeighbors(Grid grid, int x, int y) {
  int count = 0;
  for (int dx = -1; dx <= 1; dx++) {
    for (int dy = -1; dy <= 1; dy++) {
      if (dx == 0 && dy == 0) continue;
      int nx = x + dx;
      int ny = y + dy;
      if (nx >= 0 && nx < grid.length && ny >= 0 && ny < grid[0].length) {
        if (grid[nx][ny] == '#') count++;
      }
    }
  }
  return count;
}

Grid step(Grid grid, {bool corners = false}) {
  Grid newGrid = List.generate(grid.length, (i) => List.from(grid[i]));
  for (int x = 0; x < grid.length; x++) {
    for (int y = 0; y < grid[0].length; y++) {
      int count = countOnNeighbors(grid, x, y);
      if (grid[x][y] == '#') {
        newGrid[x][y] = (count == 2 || count == 3) ? '#' : '.';
      } else {
        newGrid[x][y] = (count == 3) ? '#' : '.';
      }
    }
  }

  if (corners) {
    newGrid[0][0] = '#';
    newGrid[0][grid[0].length - 1] = '#';
    newGrid[grid.length - 1][0] = '#';
    newGrid[grid.length - 1][grid[0].length - 1] = '#';
  }

  return newGrid;
}

int countOnLights(Grid grid) {
  int count = 0;
  for (var row in grid) {
    count += row.where((cell) => cell == '#').length;
  }
  return count;
}

void main() async {
  var grid = await readInput('input.txt');
  for (int i = 0; i < 100; i++) {
    grid = step(grid);
  }
  print('Part 1: ${countOnLights(grid)}');

  grid = await readInput('input.txt');
  grid[0][0] = '#';
  grid[0][grid[0].length - 1] = '#';
  grid[grid.length - 1][0] = '#';
  grid[grid.length - 1][grid[0].length - 1] = '#';
  for (int i = 0; i < 100; i++) {
    grid = step(grid, corners: true);
  }
  print('Part 2: ${countOnLights(grid)}');
}
