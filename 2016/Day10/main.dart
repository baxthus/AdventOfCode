import 'dart:collection';
import 'dart:io';

class Bot {
  int low = -1;
  int high = -1;
  int lowTarget = -1;
  int highTarget = -1;
  bool lowIsOutput = false;
  bool highIsOutput = false;
}

Map<int, Bot> bots = {};
Map<int, int> outputs = {};

void giveChip(int botId, int value) {
  Bot bot = bots.putIfAbsent(botId, () => Bot());
  if (bot.low == -1) {
    bot.low = value;
  } else {
    bot.high = value;
    if (bot.low > bot.high) {
      int temp = bot.low;
      bot.low = bot.high;
      bot.high = temp;
    }
  }
  bots[botId] = bot;
}

void processBot(int botId) {
  Bot bot = bots[botId]!;
  if (bot.low != -1 && bot.high != -1) {
    if (bot.low == 17 && bot.high == 61) {
      print(
        "Bot $botId is responsible for comparing value-61 microchips and value-17 microchips",
      );
    }

    if (bot.lowIsOutput) {
      outputs[bot.lowTarget] = bot.low;
    } else {
      giveChip(bot.lowTarget, bot.low);
      processBot(bot.lowTarget);
    }

    if (bot.highIsOutput) {
      outputs[bot.highTarget] = bot.high;
    } else {
      giveChip(bot.highTarget, bot.high);
      processBot(bot.highTarget);
    }

    bot.low = -1;
    bot.high = -1;
  }
  bots[botId] = bot;
}

void main() async {
  Queue<List<int>> initialChips = Queue();

  List<String> lines = await File('input.txt').readAsLines();

  for (String line in lines) {
    List<String> words = line.split(' ');

    if (words[0] == 'value') {
      int value = int.parse(words[1]);
      int botId = int.parse(words[5]);
      initialChips.add([botId, value]);
    } else if (words[0] == 'bot') {
      int botId = int.parse(words[1]);
      String lowType = words[5];
      int lowTarget = int.parse(words[6]);
      String highType = words[10];
      int highTarget = int.parse(words[11]);

      Bot bot = bots.putIfAbsent(botId, () => Bot());
      bot.lowTarget = lowTarget;
      bot.highTarget = highTarget;
      bot.lowIsOutput = (lowType == 'output');
      bot.highIsOutput = (highType == 'output');
      bots[botId] = bot;
    }
  }

  while (initialChips.isNotEmpty) {
    List<int> instruction = initialChips.removeFirst();
    int botId = instruction[0];
    int value = instruction[1];
    giveChip(botId, value);
    processBot(botId);
  }

  final product = outputs[0]! * outputs[1]! * outputs[2]!;
  print("The product of the values in outputs 0, 1, and 2 is: $product");
}
