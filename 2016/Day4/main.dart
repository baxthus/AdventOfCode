import 'dart:io';

class Room {
  String name;
  int sectorId;
  String checksum;

  Room(this.name, this.sectorId, this.checksum);
}

List<Room> parseInput(String filename) {
  final file = File(filename);
  final lines = file.readAsLinesSync();
  final rooms = <Room>[];

  for (var line in lines) {
    final lastDash = line.lastIndexOf('-');
    final bracketStart = line.indexOf('[');
    final bracketEnd = line.indexOf(']');

    final name = line.substring(0, lastDash);
    final sectorId = int.parse(line.substring(lastDash + 1, bracketStart));
    final checksum = line.substring(bracketStart + 1, bracketEnd);

    rooms.add(Room(name, sectorId, checksum));
  }

  return rooms;
}

String calculateChecksum(String name) {
  final frequency = <String, int>{};

  for (var c in name.split('')) {
    if (c != '-') {
      frequency[c] = (frequency[c] ?? 0) + 1;
    }
  }

  final freqList = frequency.entries.toList();
  freqList.sort((a, b) {
    if (a.value == b.value) {
      return a.key.compareTo(b.key);
    }
    return b.value.compareTo(a.value);
  });

  return freqList.take(5).map((e) => e.key).join();
}

String decryptName(String name, int sectorId) {
  final decryptedName = StringBuffer();

  for (var c in name.split('')) {
    if (c == '-') {
      decryptedName.write(' ');
    } else {
      final newChar = String.fromCharCode(
          ((c.codeUnitAt(0) - 'a'.codeUnitAt(0) + sectorId) % 26) +
              'a'.codeUnitAt(0));
      decryptedName.write(newChar);
    }
  }

  return decryptedName.toString();
}

void main() {
  final rooms = parseInput('input.txt');
  var sumOfSectorIds = 0;
  var northPoleSectorId = -1;

  for (var room in rooms) {
    final checksum = calculateChecksum(room.name);
    if (checksum == room.checksum) {
      sumOfSectorIds += room.sectorId;
      final decryptedName = decryptName(room.name, room.sectorId);
      if (decryptedName.contains('northpole')) {
        northPoleSectorId = room.sectorId;
      }
    }
  }

  print('Part 1: $sumOfSectorIds');
  print('Part 2: $northPoleSectorId');
}
