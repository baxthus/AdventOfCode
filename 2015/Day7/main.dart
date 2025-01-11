import 'dart:io';

Map<String, int> wireValues = {};
Map<String, List<String>> instructions = {};

int getWireValue(String wire) {
  if (wireValues.containsKey(wire)) {
    return wireValues[wire]!;
  }
  if (int.tryParse(wire) != null) {
    return int.parse(wire);
  }

  List<String> instruction = instructions[wire]!;
  late int result;

  if (instruction.length == 1) {
    result = getWireValue(instruction[0]);
  } else if (instruction.length == 2) {
    result = ~getWireValue(instruction[1]) & 0xffff;
  } else {
    int left = getWireValue(instruction[0]);
    int right = getWireValue(instruction[2]);
    String op = instruction[1];

    if (op == 'AND') {
      result = left & right;
    } else if (op == 'OR') {
      result = left | right;
    } else if (op == 'LSHIFT') {
      result = left << right;
    } else if (op == 'RSHIFT') {
      result = left >> right;
    } else {
      throw Exception('Unknown operator: $op');
    }
  }

  wireValues[wire] = result;
  return result;
}

int solveCircuit({bool overrideB = false, int bValue = 0}) {
  wireValues.clear();
  if (overrideB) {
    wireValues['b'] = bValue;
  }
  return getWireValue('a');
}

void main() async {
  final lines = await File('input.txt').readAsLines();

  for (var line in lines) {
    List<String> tokens = line.split(' ');
    String wire = tokens.last;
    tokens.removeLast();
    tokens.removeLast(); // Remove the '->'
    instructions[wire] = tokens;
  }

  int part1 = getWireValue('a');
  print('Part 1: $part1');
  print('Part 2: ${solveCircuit(overrideB: true, bValue: part1)}');
}
