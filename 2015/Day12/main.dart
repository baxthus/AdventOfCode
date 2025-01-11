import 'dart:convert';
import 'dart:io';

int sumNumbersInJson(dynamic data) {
  if (data is Map)
    return data.values.map(sumNumbersInJson).fold(0, (a, b) => a + b);
  else if (data is List)
    return data.map(sumNumbersInJson).fold(0, (a, b) => a + b);
  else if (data is int) return data;
  return 0;
}

int sumNumbersInJsonWithoutRed(dynamic data) {
  if (data is Map) {
    if (data.values.contains('red')) return 0;
    return data.values.map(sumNumbersInJsonWithoutRed).fold(0, (a, b) => a + b);
  } else if (data is List)
    return data.map(sumNumbersInJsonWithoutRed).fold(0, (a, b) => a + b);
  else if (data is int) return data;
  return 0;
}

void main() async {
  final data = json.decode(await File('input.txt').readAsString());

  print('Part 1: ${sumNumbersInJson(data)}');
  print('Part 2: ${sumNumbersInJsonWithoutRed(data)}');
}
