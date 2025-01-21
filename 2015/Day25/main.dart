import 'dart:io';

void main() async {
  final line = await File('input.txt').readAsString();

  print('Result: ${parse(line.trim())}');
}

const int divider = 33554393;
const int initialCode = 20151125;
const int multiplier = 252533;

int getCodeAtPosition(int row, int col) {
  final diagonal = row + col - 1;
  final sequenceNumber = (diagonal * (diagonal - 1)) ~/ 2 + col;

  int code = initialCode;
  for (int i = 1; i < sequenceNumber; ++i) {
    code = (code * multiplier) % divider;
  }

  return code;
}

int parse(String line) {
  final regex = RegExp(r'Enter the code at row (\d+), column (\d+).');
  final match = regex.firstMatch(line)!;
  final row = int.parse(match.group(1)!);
  final col = int.parse(match.group(2)!);

  return getCodeAtPosition(row, col);
}
