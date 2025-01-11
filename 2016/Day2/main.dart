import 'dart:io';

List<String> readFile(String filename) {
  try {
    return File(filename).readAsLinesSync();
  } catch (e) {
    print('Unable to open file');
    exit(1);
  }
}

Map<String, List<int>> keypad = {
  '1': [0, 2],
  '2': [1, 1],
  '3': [1, 2],
  '4': [1, 3],
  '5': [2, 0],
  '6': [2, 1],
  '7': [2, 2],
  '8': [2, 3],
  '9': [2, 4],
  'A': [3, 1],
  'B': [3, 2],
  'C': [3, 3],
  'D': [4, 2]
};

void main() {
  var instructions = readFile('input.txt');

  Map<int, Map<int, String>> reverseKeypad = {};
  keypad.forEach((key, value) {
    reverseKeypad.putIfAbsent(value[0], () => {})[value[1]] = key;
  });

  var x1 = 1, y1 = 1; // Part 1
  var x2 = 2, y2 = 0; // Part 2

  var code = '';
  var code2 = '';

  for (var instruction in instructions) {
    for (var move in instruction.split('')) {
      int newX2 = x2, newY2 = y2;
      switch (move) {
        case 'U':
          if (y1 > 0) y1--;
          newX2 = x2 - 1;
          break;
        case 'D':
          if (y1 < 2) y1++;
          newX2 = x2 + 1;
          break;
        case 'L':
          if (x1 > 0) x1--;
          newY2 = y2 - 1;
          break;
        case 'R':
          if (x1 < 2) x1++;
          newY2 = y2 + 1;
          break;
      }
      if (reverseKeypad.containsKey(newX2) &&
          reverseKeypad[newX2]!.containsKey(newY2)) {
        x2 = newX2;
        y2 = newY2;
      }
    }
    code += (y1 * 3 + x1 + 1).toString();
    code2 += reverseKeypad[x2]![y2]!;
  }

  print('Part 1: $code');
  print('Part 2: $code2');
}
