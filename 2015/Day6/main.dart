import 'dart:io';

int processLights(List<String> instructions) {
  var grid = List.generate(1000, (_) => List.filled(1000, false));

  for (var instruction in instructions) {
    List<String> parts = instruction.split(' ');
    if (parts[0] == 'turn') {
      String action = parts[1];
      List<int> start = parts[2].split(',').map(int.parse).toList();
      List<int> end = parts[4].split(',').map(int.parse).toList();
      for (int i = start[0]; i <= end[0]; i++) {
        for (int j = start[1]; j <= end[1]; j++) {
          grid[i][j] = (action == 'on');
        }
      }
    } else if (parts[0] == 'toggle') {
      List<int> start = parts[1].split(',').map(int.parse).toList();
      List<int> end = parts[3].split(',').map(int.parse).toList();
      for (int i = start[0]; i <= end[0]; i++) {
        for (int j = start[1]; j <= end[1]; j++) {
          grid[i][j] = !grid[i][j];
        }
      }
    }
  }

  return grid.fold(0, (sum, row) => sum + row.where((light) => light).length);
}

int processLightBrightness(List<String> instructions) {
  var grid = List.generate(1000, (_) => List.filled(1000, 0));

  for (var instruction in instructions) {
    List<String> parts = instruction.split(' ');
    if (parts[0] == 'turn') {
      var action = parts[1];
      List<int> start = parts[2].split(',').map(int.parse).toList();
      List<int> end = parts[4].split(',').map(int.parse).toList();
      for (int i = start[0]; i <= end[0]; i++) {
        for (int j = start[1]; j <= end[1]; j++) {
          if (action == 'on') {
            grid[i][j]++;
          } else if (action == 'off') {
            grid[i][j] = (grid[i][j] - 1).clamp(0, grid[i][j]);
          }
        }
      }
    } else if (parts[0] == 'toggle') {
      List<int> start = parts[1].split(',').map(int.parse).toList();
      List<int> end = parts[3].split(',').map(int.parse).toList();
      for (int i = start[0]; i <= end[0]; i++) {
        for (int j = start[1]; j <= end[1]; j++) {
          grid[i][j] += 2;
        }
      }
    }
  }

  return grid.fold(0, (sum, row) => sum + row.reduce((a, b) => a + b));
}

void main() async {
  var instructions = await File('input.txt').readAsLines();

  print('Part 1: ${processLights(instructions)}');
  print('Part 2: ${processLightBrightness(instructions)}');
}
