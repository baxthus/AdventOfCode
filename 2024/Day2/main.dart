import 'dart:io';

bool isSafe(List<int> levels) {
  if (levels.length < 2) return true;

  bool increasing = levels[1] > levels[0];

  for (int i = 1; i < levels.length; ++i) {
    int diff = levels[i] - levels[i - 1];
    if (increasing && diff <= 0) return false;
    if (!increasing && diff >= 0) return false;
    if (diff.abs() < 1 || diff.abs() > 3) return false;
  }

  return true;
}

bool isSafeWithDampener(List<int> levels) {
  if (isSafe(levels)) return true;

  for (int i = 0; i < levels.length; i++) {
    List<int> tempLevels = List.from(levels)..removeAt(i);
    if (isSafe(tempLevels)) return true;
  }

  return false;
}

void main() async {
  final file = File('input.txt');
  final lines = await file.readAsLines();
  int safeCount = 0;
  int safeCountWithDampener = 0;

  for (var line in lines) {
    List<int> levels = line.split(' ').map((e) => int.parse(e)).toList();

    if (isSafe(levels)) safeCount++;
    if (isSafeWithDampener(levels)) safeCountWithDampener++;
  }

  print('Part 1: $safeCount');
  print('Part 2: $safeCountWithDampener');
}
