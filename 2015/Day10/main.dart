String lookAndSay(String input) {
  var result = StringBuffer();
  var count = 1;

  for (var i = 1; i <= input.length; ++i) {
    if (i < input.length && input[i] == input[i - 1]) {
      count++;
    } else {
      result.write('$count${input[i - 1]}');
      count = 1;
    }
  }

  return result.toString();
}

void main() {
  var input = '3113322113';

  for (var i = 0; i < 40; i++) {
    input = lookAndSay(input);
  }

  print('Part 1: ${input.length}');

  for (var i = 0; i < 10; i++) {
    input = lookAndSay(input);
  }

  print('Part 2: ${input.length}');
}
