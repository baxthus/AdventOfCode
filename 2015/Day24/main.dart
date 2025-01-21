import 'dart:io';

void main() async {
  final weights = await readInput('input.txt');
  print('Part 1: ${findIdealQuantomEntanglement(weights, 3)}');
  print('Part 2: ${findIdealQuantomEntanglement(weights, 4)}');
}

int calculateQuantumEntanglement(List<int> group) {
  return group.fold(1, (acc, weight) => acc * weight);
}

bool findCombination(List<int> weights, int targetWeight, int groupSize,
    List<int> combination, int start, int currentSum) {
  if (combination.length == groupSize) return currentSum == targetWeight;
  for (int i = start; i < weights.length; i++) {
    combination.add(weights[i]);
    if (findCombination(weights, targetWeight, groupSize, combination, i + 1,
        currentSum + weights[i])) return true;
    combination.removeLast();
  }
  return false;
}

int findIdealQuantomEntanglement(List<int> weights, int numGroups) {
  final totalWeight = weights.reduce((a, b) => a + b);
  final targetWeight = totalWeight ~/ numGroups;
  final n = weights.length;

  int minQE = double.maxFinite.toInt();

  for (int groupSize = 1; groupSize <= n ~/ numGroups; ++groupSize) {
    final combination = <int>[];
    if (findCombination(weights, targetWeight, groupSize, combination, 0, 0)) {
      final qe = calculateQuantumEntanglement(combination);
      if (qe < minQE) {
        minQE = qe;
      }
    }
    if (minQE != double.maxFinite.toInt()) {
      break;
    }
  }

  return minQE;
}

Future<List<int>> readInput(String filename) async {
  return await File(filename)
      .readAsLines()
      .then((l) => l.map(int.parse).toList());
}
