import 'dart:collection';
import 'dart:io';

List<T> rotate<T>(List<T> list, int steps) {
  if (list.isEmpty) return list;
  final n = list.length;
  final offset = steps % n;
  if (offset == 0) return List.from(list);

  final d = DoubleLinkedQueue<T>.from(list);
  if (offset > 0) {
    for (var i = 0; i < offset; i++) {
      d.addFirst(d.removeLast());
    }
  } else {
    for (var i = 0; i < -offset; i++) {
      d.addLast(d.removeFirst());
    }
  }
  return d.toList();
}

List<String> scramble(List<String> password, String instruction) {
  final parts = instruction.split(' ');
  var p = List.of(password);

  switch (parts[0]) {
    case 'swap':
      if (parts[1] == 'position') {
        final pos1 = int.parse(parts[2]);
        final pos2 = int.parse(parts[5]);
        final temp = p[pos1];
        p[pos1] = p[pos2];
        p[pos2] = temp;
      } else {
        final let1 = parts[2];
        final let2 = parts[5];
        final pos1 = p.indexOf(let1);
        final pos2 = p.indexOf(let2);
        final temp = p[pos1];
        p[pos1] = p[pos2];
        p[pos2] = temp;
      }
      break;
    case 'rotate':
      if (parts[1] == 'left') {
        final steps = int.parse(parts[2]);
        p = rotate(p, -steps);
      } else if (parts[1] == 'right') {
        final steps = int.parse(parts[2]);
        p = rotate(p, steps);
      } else {
        final letter = parts[6];
        final idx = p.indexOf(letter);
        var rotations = 1 + idx;
        if (idx >= 4) rotations++;
        p = rotate(p, rotations);
      }
      break;
    case 'reverse':
      final pos1 = int.parse(parts[2]);
      final pos2 = int.parse(parts[4]);
      final sub = p.sublist(pos1, pos2 + 1).reversed.toList();
      p.replaceRange(pos1, pos2 + 1, sub);
      break;
    case 'move':
      final pos1 = int.parse(parts[2]);
      final pos2 = int.parse(parts[5]);
      final letter = p.removeAt(pos1);
      p.insert(pos2, letter);
      break;
  }

  return p;
}

List<String> unscramble(List<String> password, String instruction) {
  final parts = instruction.split(' ');
  var p = List.of(password);

  switch (parts[0]) {
    case 'swap':
      return scramble(p, instruction);
    case 'rotate':
      if (parts[1] == 'left') {
        final steps = int.parse(parts[2]);
        p = rotate(p, steps);
      } else if (parts[1] == 'right') {
        final steps = int.parse(parts[2]);
        p = rotate(p, -steps);
      } else {
        const List<int> leftRotationsForUnscramble = [1, 1, 6, 2, 7, 3, 0, 4];
        final letter = parts[6];
        final idx = p.indexOf(letter);
        final rotations = leftRotationsForUnscramble[idx];
        p = rotate(p, -rotations);
      }
      break;
    case 'reverse':
      return scramble(p, instruction);
    case 'move':
      final pos1 = int.parse(parts[2]);
      final pos2 = int.parse(parts[5]);
      final letter = p.removeAt(pos2);
      p.insert(pos1, letter);
      break;
  }

  return p;
}

void main() {
  final instructions = <String>[];
  while (true) {
    final line = stdin.readLineSync();
    if (line == null || line.trim().isEmpty) break;
    instructions.add(line);
  }

  var password1 = 'abcdefgh'.split('');
  for (final instruction in instructions) {
    password1 = scramble(password1, instruction);
  }
  print('Part 1: ${password1.join()}');

  var password2 = 'fbgdceah'.split('');
  for (final instruction in instructions.reversed) {
    password2 = unscramble(password2, instruction);
  }
  print('Part 2: ${password2.join()}');
}
