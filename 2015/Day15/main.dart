import 'dart:io';
import 'dart:math';

typedef Ingredients = Map<String, List<int>>;
typedef Amounts = List<int>;

void main() async {
  final ingredients = await parseInput('input.txt');
  print('Part 1: ${findBestScore(ingredients)}');
  print('Part 2: ${findBestCookie(ingredients)}');
}

int calculateScore(Ingredients ingredients, Amounts amounts) {
  final totals = List<int>.filled(5, 0);

  for (var i = 0; i < ingredients.values.length; i++) {
    final ingredient = ingredients.values.elementAt(i);
    final amount = amounts[i];
    for (var j = 0; j < 5; j++) {
      totals[j] += ingredient[j] * amount;
    }
  }

  var score = 1;
  for (var i = 0; i < 4; i++) {
    score *= max(0, totals[i]);
  }

  return score;
}

int calculateScore2(Ingredients ingredients, Amounts amounts) {
  final totals = List<int>.filled(5, 0);

  for (var i = 0; i < ingredients.values.length; i++) {
    final ingredient = ingredients.values.elementAt(i);
    final amount = amounts[i];
    for (var j = 0; j < 5; j++) {
      totals[j] += ingredient[j] * amount;
    }
  }

  if (totals[4] != 500) {
    return 0;
  }

  var score = 1;
  for (var i = 0; i < 4; i++) {
    score *= max(0, totals[i]);
  }

  return score;
}

int findBestCookie(Ingredients ingredients) {
  var bestScore = 0;

  for (var amounts in generateCombinations(ingredients.length, 100)) {
    final score = calculateScore2(ingredients, amounts);
    bestScore = max(bestScore, score);
  }

  return bestScore;
}

int findBestScore(Ingredients ingredients) {
  var bestScore = 0;

  for (var amounts in generateCombinations(ingredients.length, 100)) {
    final score = calculateScore(ingredients, amounts);
    bestScore = max(bestScore, score);
  }

  return bestScore;
}

Iterable<Amounts> generateCombinations(int length, int total) sync* {
  if (length == 1) {
    yield [total];
  } else {
    for (var i = 0; i <= total; i++) {
      for (var combination in generateCombinations(length - 1, total - i)) {
        yield [i, ...combination];
      }
    }
  }
}

Future<Ingredients> parseInput(String filename) async {
  Ingredients ingredients = {};
  final lines = await File(filename).readAsLines();

  final regex = RegExp(r'-?\d+');

  for (var line in lines) {
    final parts = line.split(': ');
    final name = parts[0];
    final properties =
        regex.allMatches(parts[1]).map((m) => int.parse(m.group(0)!)).toList();
    ingredients[name] = properties;
  }

  return ingredients;
}
