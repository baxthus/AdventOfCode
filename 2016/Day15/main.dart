import 'dart:io';
import 'dart:math';

class Disc {
  final int id; // Disc number (k)
  final int numPos; // Number of positions (N_k)
  final int startPos; // Starting position at time=0 (P_k)

  Disc(this.id, this.numPos, this.startPos);

  @override
  String toString() {
    return 'Disc(id: $id, numPos: $numPos, startPos: $startPos)';
  }
}

bool checkTime(int t, List<Disc> discs) {
  for (final disc in discs) {
    int timeAtDisc = t + disc.id;
    int positionAtTime = (disc.startPos + timeAtDisc) % disc.numPos;
    if (positionAtTime != 0) return false;
  }
  return true;
}

int findFirstValidTime(List<Disc> discs) {
  int t = 0;
  while (true) {
    if (checkTime(t, discs)) return t;
    t++;
  }
}

void main() {
  List<Disc> discs = [];
  String? line;

  final pattern = RegExp(
    r'Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+).',
  );

  int maxId = 0;

  while ((line = stdin.readLineSync()) != null) {
    if (line!.isEmpty) continue;

    final match = pattern.firstMatch(line);

    if (match != null) {
      if (match.groupCount == 3) {
        int id = int.parse(match.group(1)!);
        int numPos = int.parse(match.group(2)!);
        int startPos = int.parse(match.group(3)!);
        discs.add(Disc(id, numPos, startPos));
        maxId = max(maxId, id);
      }
    }
  }

  if (discs.isEmpty) {
    print('No valid discs found.');
    return;
  }

  int t1 = findFirstValidTime(discs);
  print('First time the capsule passes through all discs: $t1');

  int newDiscId = maxId + 1;
  int newDiscNumPos = 11;
  int newDiscStartPos = 0;
  discs.add(Disc(newDiscId, newDiscNumPos, newDiscStartPos));

  int t2 = findFirstValidTime(discs);
  print('First time the capsule passes through all discs with new disc: $t2');
}
