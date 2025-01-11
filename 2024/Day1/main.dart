import 'dart:io';

void main() async {
  final file = File('input.txt');
  final lines = await file.readAsLines();

  List<int> left = [];
  List<int> right = [];

  for (var line in lines) {
    final parts = line.split('   ');
    final a = int.parse(parts[0]);
    final b = int.parse(parts[1]);
    left.add(a);
    right.add(b);
  }

  left.sort();
  right.sort();

  var totalDistance = 0;
  for (var i = 0; i < left.length; i++) {
    totalDistance += (right[i] - left[i]).abs();
  }

  print('Part 1: $totalDistance');

  Map<int, int> rightCounts = {};
  for (var num in right) {
    rightCounts[num] = (rightCounts[num] ?? 0) + 1;
  }

  var similarityScore = 0;
  for (var num in left) {
    similarityScore += num * (rightCounts[num] ?? 0);
  }

  print('Part 2: $similarityScore');
}
