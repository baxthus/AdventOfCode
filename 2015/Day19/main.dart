import 'dart:io';
import 'dart:math';

void main() async {
  var (replacements, molecule) = await parseInput('input.txt');

  print('Part 1: ${mutate(molecule, replacements).length}');
  print('Part 2: ${search(molecule, replacements)}');
}

Set<String> mutate(String molecule, List<Replacement> replacements) {
  var distinctMolecules = <String>{};
  for (var rep in replacements) {
    for (var i = 0; i < molecule.length; i++) {
      if (molecule.startsWith(rep.from, i)) {
        var newMolecule = molecule.substring(0, i) +
            rep.to +
            molecule.substring(i + rep.from.length);
        distinctMolecules.add(newMolecule);
      }
    }
  }
  return distinctMolecules;
}

Future<(List<Replacement>, String)> parseInput(String filename) async {
  var lines = await File(filename).readAsLines();

  var replacements = <Replacement>[];
  var molecule = '';

  for (var line in lines) {
    if (line.contains('=>')) {
      var parts = line.split(' => ');
      replacements.add(Replacement(parts[0], parts[1]));
    } else if (line.isNotEmpty) {
      molecule = line;
    }
  }

  return (replacements, molecule);
}

int search(String molecule, List<Replacement> replacements) {
  var target = molecule;
  var mutations = 0;

  while (target != 'e') {
    var tmp = target;
    for (var rep in replacements) {
      var index = target.indexOf(rep.to);
      if (index >= 0) {
        target = target.substring(0, index) +
            rep.from +
            target.substring(index + rep.to.length);
        mutations++;
        break;
      }
    }

    if (tmp == target) {
      target = molecule;
      mutations = 0;
      replacements.shuffle();
    }
  }

  return mutations;
}

void shuffleReplacementes(List<Replacement> replacements) {
  var random = new Random();
  for (var i = replacements.length - 1; i > 0; i--) {
    var j = random.nextInt(i + 1);
    var temp = replacements[i];
    replacements[i] = replacements[j];
    replacements[j] = temp;
  }
}

class Replacement {
  String from, to;
  Replacement(this.from, this.to);
}
