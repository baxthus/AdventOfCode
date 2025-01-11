import 'dart:io';

void main() async {
  MfcsamReading mfcsamReading = {
    'children': 3,
    'cats': 7,
    'samoyeds': 2,
    'pomeranians': 3,
    'akitas': 0,
    'vizslas': 0,
    'goldfish': 5,
    'trees': 3,
    'cars': 2,
    'perfumes': 1
  };

  Aunts aunts = await parseInput('input.txt');

  print('Part 1: ${findMatchingSue(aunts, mfcsamReading)}');
  print('Part 2: ${findRealSue(aunts, mfcsamReading)}');
}

int? findMatchingSue(Aunts aunts, MfcsamReading mfcsamReading) {
  for (var entry in aunts.entries) {
    final sue = entry.key;
    final attributes = entry.value;
    if (attributes.entries
        .every((attr) => mfcsamReading[attr.key] == attr.value)) {
      return sue;
    }
  }
  return null;
}

int? findRealSue(Aunts aunts, MfcsamReading mfcsamReading) {
  for (var entry in aunts.entries) {
    final sue = entry.key;
    final attributes = entry.value;
    if (attributes.entries.every((attr) =>
        matchAttribute(attr.key, attr.value, mfcsamReading[attr.key]))) {
      return sue;
    }
  }
  return null;
}

bool matchAttribute(String attr, int value, int? mfcsamValue) {
  if (attr == 'cats' || attr == 'trees') {
    return mfcsamValue != null ? value > mfcsamValue : true;
  } else if (attr == 'pomeranians' || attr == 'goldfish') {
    return mfcsamValue != null ? value < mfcsamValue : true;
  } else {
    return mfcsamValue != null ? value == mfcsamValue : true;
  }
}

Future<Aunts> parseInput(String filename) async {
  Aunts aunts = {};
  final lines = await new File(filename).readAsLines();

  final regex = RegExp(r'Sue (\d+): (.*)');

  for (var line in lines) {
    final match = regex.firstMatch(line.trim());
    if (match != null) {
      final sueMember = int.parse(match.group(1)!);
      final attributes = match.group(2)!.split(', ');
      final aunt_data = <String, int>{};
      for (var attribute in attributes) {
        final parts = attribute.split(': ');
        aunt_data[parts[0]] = int.parse(parts[1]);
      }
      aunts[sueMember] = aunt_data;
    }
  }

  return aunts;
}

typedef Aunts = Map<int, Map<String, int>>;

typedef MfcsamReading = Map<String, int>;
