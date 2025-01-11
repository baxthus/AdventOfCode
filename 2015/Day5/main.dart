import 'dart:io';

bool isNiceString(String s) {
  const vowels = 'aeiou';
  const disallowed = ['ab', 'cd', 'pq', 'xy'];
  int vowelCount = s.split('').where(vowels.contains).length;
  bool hasDoubleLetter = false;
  for (int i = 0; i < s.length - 1; i++) {
    if (s[i] == s[i + 1]) {
      hasDoubleLetter = true;
      break;
    }
  }
  bool containsDisallowed = disallowed.any(s.contains);
  return vowelCount >= 3 && hasDoubleLetter && !containsDisallowed;
}

bool isNiceString2(String s) {
  final repeatingPair = RegExp(r'(..).*\1');
  final repeatingLetterWithOneBetween = RegExp(r'(.).\1');
  bool hasRepeatingPair = repeatingPair.hasMatch(s);
  bool hasRepeatingLetterWithOneBetween =
      repeatingLetterWithOneBetween.hasMatch(s);
  return hasRepeatingPair && hasRepeatingLetterWithOneBetween;
}

int countNiceStrings(List<String> strings, bool Function(String) function) {
  return strings.where(function).length;
}

void main() async {
  final file = File('input.txt');
  final strings = await file.readAsLines();

  print('Part 1: ${countNiceStrings(strings, isNiceString)}');
  print('Part 2: ${countNiceStrings(strings, isNiceString2)}');
}
