import 'dart:io';

int decompressedLength(String input) {
  int length = 0;
  int i = 0;

  while (i < input.length) {
    if (input[i] == '(') {
      // Find the end of the marker
      int markerEnd = input.indexOf(')', i);
      if (markerEnd == -1) throw Exception('Invalid marker at position $i');

      // Parse the marker
      String marker = input.substring(i + 1, markerEnd);
      int xPos = marker.indexOf('x');
      if (xPos == -1) throw Exception('Invalid marker at position $i');

      int charsToRepeat = int.parse(marker.substring(0, xPos));
      int repeatCount = int.parse(marker.substring(xPos + 1));

      // Move the index post the marker
      i = markerEnd + 1;

      // Add the length of the repeated string
      length += charsToRepeat * repeatCount;

      // Move the index post the repeated string
      i += charsToRepeat;
    } else if (input[i] != ' ' && input[i] != '\n' && input[i] != '\t') {
      // Regular character, just count it
      length++;
      i++;
    } else {
      // Skip whitespace
      i++;
    }
  }

  return length;
}

int decompressedLength2(String input, {int start = 0, int? end}) {
  int length = 0;
  int i = start;
  end ??= input.length;

  while (i < end) {
    if (input[i] == '(') {
      // Find the end of the marker
      int markerEnd = input.indexOf(')', i);
      if (markerEnd == -1) throw Exception('Invalid marker at position $i');

      // Parse the marker
      String marker = input.substring(i + 1, markerEnd);
      int xPos = marker.indexOf('x');
      if (xPos == -1) throw Exception('Invalid marker at position $i');

      int charsToRepeat = int.parse(marker.substring(0, xPos));
      int repeatCount = int.parse(marker.substring(xPos + 1));

      // Move the index post the marker
      i = markerEnd + 1;

      // Recursively calculate the length of the repeated string
      int repeatedLength = decompressedLength2(
        input,
        start: i,
        end: i + charsToRepeat,
      );
      length += repeatedLength * repeatCount;

      // Move the index post the repeated string
      i += charsToRepeat;
    } else if (input[i] != ' ' && input[i] != '\n' && input[i] != '\t') {
      // Regular character, just count it
      length++;
      i++;
    } else {
      // Skip whitespace
      i++;
    }
  }

  return length;
}

void main() async {
  String input = await File('input.txt').readAsString();

  print('Part 1: ${decompressedLength(input)}');
  print('Part 2: ${decompressedLength2(input)}');
}
