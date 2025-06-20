import 'dart:convert';
import 'dart:io';

int solve1(String input) {
  var total = 0;

  final pattern = RegExp(r'mul\((\d{1,3}),(\d{1,3})\)');
  final matches = pattern.allMatches(input);

  for (final match in matches) {
    if (match.group(1) != null && match.group(2) != null) {
      final x = int.parse(match.group(1)!);
      final y = int.parse(match.group(2)!);
      total += x * y;
    }
  }

  return total;
}

int solve2(String input) {
  var total = 0;
  var enabled = true;
  final pattern = RegExp(r"(do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\))");
  final matches = pattern.allMatches(input);

  for (final match in matches) {
    final instruction = match.group(1);
    if (instruction == null) continue;

    if (instruction == 'do()') {
      enabled = true;
    } else if (instruction == "don't()") {
      enabled = false;
    } else if (enabled && instruction.startsWith('mul')) {
      if (match.group(2) != null && match.group(3) != null) {
        final x = int.parse(match.group(2)!);
        final y = int.parse(match.group(3)!);
        total += x * y;
      }
    }
  }

  return total;
}

Future<void> main() async {
  String input = await stdin.transform(utf8.decoder).join();

  print('Part 1: ${solve1(input)}');
  print('Part 2: ${solve2(input)}');
}
