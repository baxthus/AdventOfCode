import 'dart:io';

int calculateFinalFloor(String instructions) {
  int floor = 0;
  for (var c in instructions.split('')) {
    if (c == '(')
      floor++;
    else if (c == ')') floor--;
  }
  return floor;
}

int findBasementEntry(String instructions) {
  int floor = 0;
  for (int position = 0; position < instructions.length; position++) {
    if (instructions[position] == '(')
      floor++;
    else if (instructions[position] == ')') floor--;

    if (floor == -1) return position + 1;
  }
  return -1;
}

void main() async {
  final file = File('input.txt');
  if (!await file.exists()) {
    print('File not found!');
    return;
  }

  final instructions = await file.readAsString();

  print('Part 1: ${calculateFinalFloor(instructions)}');
  print('Part 2: ${findBasementEntry(instructions)}');
}
