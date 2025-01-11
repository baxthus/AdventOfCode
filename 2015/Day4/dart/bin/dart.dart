import 'dart:convert';

import 'package:crypto/crypto.dart';

int findLowerstNumber(String input) {
  int number = 1;
  while (true) {
    var hashInput = utf8.encode('$input$number');
    var hash = md5.convert(hashInput).toString();
    if (hash.startsWith('00000')) return number;
    number++;
  }
}

int findLowestNumberSixZeroes(String input) {
  int number = 1;
  while (true) {
    var hashInput = utf8.encode('$input$number');
    var hash = md5.convert(hashInput).toString();
    if (hash.startsWith('000000')) return number;
    number++;
  }
}

void main(List<String> arguments) {
  const String input = 'iwrupvqb';
  print('Part 1: ${findLowerstNumber(input)}');
  print('Part 2: ${findLowestNumberSixZeroes(input)}');
}
