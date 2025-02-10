#include <fstream>
#include <iostream>
#include <map>
#include <queue>
#include <sstream>

struct Bot {
  int low = -1;
  int high = -1;
  int low_target = -1;
  int high_target = -1;
  bool low_is_output = false;
  bool high_is_output = false;
};

using BotMap = std::map<int, Bot>;
using OutputMap = std::map<int, int>;
using InstructionQueue = std::queue<std::pair<int, int>>;

BotMap bots;
OutputMap outputs;
InstructionQueue initial_chips;

void give_chip(int bot_id, int value) {
  Bot &bot = bots[bot_id];
  if (bot.low == -1) {
    bot.low = value;
  } else {
    bot.high = value;
    if (bot.low > bot.high) {
      std::swap(bot.low, bot.high);
    }
  }
}

void proccess_bot(int bot_id) {
  Bot &bot = bots[bot_id];
  if (bot.low != -1 && bot.high != -1) {
    if (bot.low == 17 && bot.high == 61) {
      std::cout << "Bot " << bot_id
                << " is responsible for comparing value-61 microchips with "
                   "value-17 microchips."
                << std::endl;
    }
    if (bot.low_is_output) {
      outputs[bot.low_target] = bot.low;
    } else {
      give_chip(bot.low_target, bot.low);
      proccess_bot(bot.low_target);
    }
    if (bot.high_is_output) {
      outputs[bot.high_target] = bot.high;
    } else {
      give_chip(bot.high_target, bot.high);
      proccess_bot(bot.high_target);
    }
    bot.low = -1;
    bot.high = -1;
  }
}

int main() {
  std::ifstream input_file("input.txt");
  std::string line;
  while (getline(input_file, line)) {
    std::stringstream ss(line);
    std::string word;
    ss >> word;
    if (word == "value") {
      int value, bot_id;
      ss >> value >> word >> word >> word >> bot_id;
      initial_chips.push({bot_id, value});
    } else if (word == "bot") {
      int bot_id, low_target, high_target;
      std::string low_type, high_type;
      ss >> bot_id >> word >> word >> word >> low_type >> low_target >> word >>
          word >> word >> high_type >> high_target;
      bots[bot_id].low_target = low_target;
      bots[bot_id].high_target = high_target;
      bots[bot_id].low_is_output = low_type == "output";
      bots[bot_id].high_is_output = high_type == "output";
    }
  }

  while (!initial_chips.empty()) {
    auto [bot_id, value] = initial_chips.front();
    initial_chips.pop();
    give_chip(bot_id, value);
    proccess_bot(bot_id);
  }

  int product = outputs[0] * outputs[1] * outputs[2];
  std::cout << "The product of the values in the outputs 0, 1, and 2 is: "
            << product << std::endl;

  return 0;
}