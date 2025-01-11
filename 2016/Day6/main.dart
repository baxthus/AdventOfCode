import 'dart:io';

String decodeMessage(List<String> messages, {bool findLeastFrequent = false}) {
  if (messages.isEmpty) return '';

  int numColumns = messages[0].length;
  List<Map<String, int>> frequencyMaps = List.generate(numColumns, (_) => {});

  for (var message in messages) {
    for (int i = 0; i < numColumns; i++) {
      String char = message[i];
      frequencyMaps[i][char] = (frequencyMaps[i][char] ?? 0) + 1;
    }
  }

  String decodedMessage = '';
  for (var frequencyMap in frequencyMaps) {
    String selectedChar = ' ';
    int selectedFrequency = findLeastFrequent ? double.maxFinite.toInt() : 0;

    frequencyMap.forEach((character, frequency) {
      if ((findLeastFrequent && frequency < selectedFrequency) ||
          (!findLeastFrequent && frequency > selectedFrequency)) {
        selectedChar = character;
        selectedFrequency = frequency;
      }
    });

    decodedMessage += selectedChar;
  }

  return decodedMessage;
}

void main() async {
  final inputFile = File('input.txt');
  List<String> messages = await inputFile.readAsLines();

  print('Part 1: ${decodeMessage(messages)}');
  print('Part 2: ${decodeMessage(messages, findLeastFrequent: true)}');
}
