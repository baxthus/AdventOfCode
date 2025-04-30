import 'dart:convert';
import 'package:crypto/crypto.dart';

String calculateMD5(String input) {
  final bytes = utf8.encode(input);
  final digest = md5.convert(bytes);
  return digest.toString();
}

String calculateStretchedMD5(String input) {
  String hash = calculateMD5(input);
  for (int i = 0; i < 2016; i++) {
    hash = calculateMD5(hash);
  }
  return hash;
}

final tripletRegex = RegExp(r'(.)\1\1');

String? findTripletChar(String hash) {
  final match = tripletRegex.firstMatch(hash);
  return match?.group(1)!;
}

bool hasQuintupletChar(String hash, String quintupletChar) {
  final quintuplet = quintupletChar * 5;
  return hash.contains(quintuplet);
}

void main() {
  const salt = "zpqevtbw";
  const targetKeys = 64;

  int index = 0;
  int keysFound = 0;
  final List<String> hashes = [];

  while (keysFound < targetKeys) {
    if (index >= hashes.length) hashes.add(calculateMD5('$salt$index'));
    final currentHash = hashes[index];
    final tripletChar = findTripletChar(currentHash);
    if (tripletChar != null) {
      for (int i = index + 1; i <= index + 1000; i++) {
        if (i >= hashes.length) {
          hashes.add(calculateMD5('$salt$i'));
        }
        final nextHash = hashes[i];
        if (hasQuintupletChar(nextHash, tripletChar)) {
          keysFound++;
          break;
        }
      }
    }
    index++;
  }

  print("Index of the 64th key: ${index - 1}");

  index = 0;
  keysFound = 0;
  hashes.clear();

  while (keysFound < targetKeys) {
    if (index >= hashes.length)
      hashes.add(calculateStretchedMD5('$salt$index'));
    final currentHash = hashes[index];
    final tripletChar = findTripletChar(currentHash);
    if (tripletChar != null) {
      for (int i = index + 1; i <= index + 1000; i++) {
        if (i >= hashes.length) {
          hashes.add(calculateStretchedMD5('$salt$i'));
        }
        final nextHash = hashes[i];
        if (hasQuintupletChar(nextHash, tripletChar)) {
          keysFound++;
          break;
        }
      }
    }
    index++;
  }

  print("Index of the 64th key with stretched MD5: ${index - 1}");
}
