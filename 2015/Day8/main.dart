import 'dart:io';

int calculateMatchsticks(String line) {
  String unquoted = line.substring(1, line.length - 1);

  int memoryCount = 0;
  for (int i = 0; i < unquoted.length; i++) {
    if (unquoted[i] == '\\') {
      if (unquoted[i + 1] == 'x') {
        i += 3;
      } else {
        i++;
      }
    }
    memoryCount++;
  }

  return line.length - memoryCount;
}

int calculateMatchsticks2(String line) {
  String encoded = '"';
  for (int i = 0; i < line.length; i++) {
    if (line[i] == '\\') {
      encoded += '\\\\';
    } else if (line[i] == '"') {
      encoded += '\\"';
    } else {
      encoded += line[i];
    }
  }
  encoded += '"';

  return encoded.length - line.length;
}

void main() async {
  final lines = await File('input.txt').readAsLines();

  int part1 = 0;
  int part2 = 0;

  for (var line in lines) {
    part1 += calculateMatchsticks(line);
    part2 += calculateMatchsticks2(line);
  }

  print('Part 1: $part1');
  print('Part 2: $part2');
}
