import 'dart:convert';
import 'dart:io';

Iterable<List<int>> combinations(List<int> elements, int r) sync* {
  if (r == 0) {
    yield [];
  } else {
    for (int i = 0; i <= elements.length - r; i++) {
      for (var combo in combinations(elements.sublist(i + 1), r - 1)) {
        yield [elements[i], ...combo];
      }
    }
  }
}

int countEggnogCombinations(List<int> containers, int target) {
  int count = 0;
  for (int r = 1; r <= containers.length; r++) {
    for (var combo in combinations(containers, r)) {
      if (combo.reduce((a, b) => a + b) == target) {
        count++;
      }
    }
  }
  return count;
}

Map<String, int> findMinContainersAndCombinations(
    List<int> containers, int target) {
  for (int r = 1; r <= containers.length; r++) {
    int count = 0;
    for (var combo in combinations(containers, r)) {
      if (combo.reduce((a, b) => a + b) == target) {
        count++;
      }
    }
    if (count > 0) {
      return {'minContainers': r, 'combinations': count};
    }
  }
  return {'minContainers': 0, 'combinations': 0};
}

void main() async {
  final file = File('input.txt');
  List<int> containers = await file
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .map(int.parse)
      .toList();

  int targetVolume = 150;

  print('Part 1: ${countEggnogCombinations(containers, targetVolume)}');
  print(
      'Part 2: ${findMinContainersAndCombinations(containers, targetVolume)['combinations']}');
}
