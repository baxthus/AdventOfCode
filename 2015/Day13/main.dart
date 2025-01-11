import 'dart:io';
import 'dart:math';

typedef Happiness = Map<String, int>;
typedef People = List<String>;

(Happiness, People) parseInput(List<String> lines) {
  var happiness = <String, int>{};
  var people = <String>{};

  for (var line in lines) {
    var parts = line.split(' ');
    var person1 = parts[0];
    var person2 = parts[parts.length - 1].replaceAll('.', '');
    var value = int.parse(parts[3]);
    if (parts[2] == 'lose') {
      value = -value;
    }
    happiness['$person1,$person2'] = value;
    people.add(person1);
  }

  return (happiness, people.toList());
}

(Happiness, People) parseInput2(List<String> lines) {
  var happiness = <String, int>{};
  var people = <String>{};

  for (var line in lines) {
    var parts = line.split(' ');
    var person1 = parts[0];
    var person2 = parts[parts.length - 1].replaceAll('.', '');
    var value = int.parse(parts[3]);
    if (parts[2] == 'lose') {
      value = -value;
    }
    happiness['$person1,$person2'] = value;
    people.add(person1);
  }

  const you = 'You';
  for (var person in people) {
    happiness['$you,$person'] = 0;
    happiness['$person,$you'] = 0;
  }
  people.add(you);

  return (happiness, people.toList());
}

int calculateHappiness(People people, Happiness happiness) {
  var total = 0;
  var n = people.length;
  for (var i = 0; i < n; i++) {
    var person = people[i];
    var left = people[(i - 1) % n];
    var right = people[(i + 1) % n];
    total += happiness['$person,$left'] ?? 0;
    total += happiness['$person,$right'] ?? 0;
  }
  return total;
}

int findOptimalArrangement(Happiness happiness, People people) {
  var maxHappiness = -999999999;
  var permutations = permute(people.sublist(1));

  for (var arrangement in permutations) {
    var currentArrangement = [people[0], ...arrangement];
    var currentHappiness = calculateHappiness(currentArrangement, happiness);
    maxHappiness = max(maxHappiness, currentHappiness);
  }

  return maxHappiness;
}

List<List<T>> permute<T>(List<T> list) {
  if (list.isEmpty) return [[]];
  var result = <List<T>>[];
  for (var i = 0; i < list.length; i++) {
    var element = list[i];
    var rest = List<T>.from(list)..removeAt(i);
    for (var perm in permute(rest)) {
      result.add([element, ...perm]);
    }
  }
  return result;
}

void main() async {
  var lines = await File('input.txt').readAsLines();

  var (happiness, people) = parseInput(lines);
  var (happiness2, people2) = parseInput2(lines);

  print('Part 1: ${findOptimalArrangement(happiness, people)}');
  print('Part 2: ${findOptimalArrangement(happiness2, people2)}');
}
