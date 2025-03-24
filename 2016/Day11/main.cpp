#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <queue>
#include <regex>
#include <string>
#include <unordered_set>
#include <vector>

struct State {
  int elevator;
  std::vector<std::pair<int, int>> items; // (generator_floor, chip_floor)
  int steps;

  std::string get_hash() const {
    std::string hash = std::to_string(elevator) + "-";

    std::vector<std::pair<int, int>> sorted_items = items;
    std::sort(sorted_items.begin(), sorted_items.end());

    for (const auto &item : sorted_items) {
      hash +=
          std::to_string(item.first) + "," + std::to_string(item.second) + ";";
    }

    return hash;
  }

  bool is_valid() const {
    for (size_t i = 0; i < items.size(); i++) {
      int chipFloor = items[i].second;

      if (chipFloor == items[i].first)
        continue;

      for (size_t j = 0; j < items.size(); j++) {
        if (j != i && items[j].first == chipFloor)
          return false;
      }
    }

    return true;
  }

  bool is_goal() {
    for (const auto &item : items) {
      if (item.first != 4 || item.second != 4)
        return false;
    }
    return true;
  }
};

std::vector<State> get_next_states(const State &current) {
  std::vector<State> next_states;
  std::vector<int> possible_floors;

  if (current.elevator < 4)
    possible_floors.push_back(current.elevator + 1);
  if (current.elevator > 1)
    possible_floors.push_back(current.elevator - 1);

  std::vector<std::pair<int, int>>
      items_on_floor; // (index, type) where type: 0=gen, 1=chip
  for (size_t i = 0; i < current.items.size(); i++) {
    if (current.items[i].first == current.elevator)
      items_on_floor.push_back({i, 0});
    if (current.items[i].second == current.elevator)
      items_on_floor.push_back({i, 1});
  }

  for (const auto &item1 : items_on_floor) {
    // try moving one item
    for (int next_floor : possible_floors) {
      State new_state = current;
      new_state.elevator = next_floor;
      new_state.steps++;

      if (item1.second == 0)
        new_state.items[item1.first].first = next_floor;
      else
        new_state.items[item1.first].second = next_floor;

      if (new_state.is_valid())
        next_states.push_back(new_state);
    }

    // try moving two items
    for (const auto &item2 : items_on_floor) {
      if (item1 == item2)
        continue;

      for (int next_floor : possible_floors) {
        State new_state = current;
        new_state.elevator = next_floor;
        new_state.steps++;

        if (item1.second == 0)
          new_state.items[item1.first].first = next_floor;
        else
          new_state.items[item1.first].second = next_floor;

        if (item2.second == 0)
          new_state.items[item2.first].first = next_floor;
        else
          new_state.items[item2.first].second = next_floor;

        if (new_state.is_valid())
          next_states.push_back(new_state);
      }
    }
  }

  return next_states;
}

State parse_input(const std::vector<std::string> &input, bool part2 = false) {
  std::map<std::string, int> element_index;
  std::vector<std::pair<int, int>> items; // (generator_floor, chip_floor)

  for (int floor = 0; floor < input.size(); floor++) {
    std::string line = input[floor];

    std::regex gen_regex("(\\w+) generator");
    auto gen_begin = std::sregex_iterator(line.begin(), line.end(), gen_regex);
    auto gen_end = std::sregex_iterator();

    for (std::sregex_iterator i = gen_begin; i != gen_end; i++) {
      std::string element = (*i)[1].str();
      if (element_index.find(element) == element_index.end()) {
        element_index[element] = items.size();
        items.push_back({floor + 1, 0});
      } else {
        items[element_index[element]].first = floor + 1;
      }
    }

    std::regex chip_regex("(\\w+)-compatible microchip");
    auto chip_begin =
        std::sregex_iterator(line.begin(), line.end(), chip_regex);
    auto chip_end = std::sregex_iterator();

    for (std::sregex_iterator i = chip_begin; i != chip_end; i++) {
      std::string element = (*i)[1].str();
      if (element_index.find(element) == element_index.end()) {
        element_index[element] = items.size();
        items.push_back({0, floor + 1});
      } else {
        items[element_index[element]].second = floor + 1;
      }
    }
  }

  if (part2) {
    items.push_back({1, 1}); // elerium generator
    items.push_back({1, 1}); // dilithium generator
  }

  return {1, items, 0};
}

int find_minimum_steps(const State &initial_state) {
  std::queue<State> queue;
  std::unordered_set<std::string> visited;

  queue.push(initial_state);
  visited.insert(initial_state.get_hash());

  while (!queue.empty()) {
    State current = queue.front();
    queue.pop();

    if (current.is_goal())
      return current.steps;

    for (const auto &next_state : get_next_states(current)) {
      std::string hash = next_state.get_hash();
      if (visited.find(hash) == visited.end()) {
        visited.insert(hash);
        queue.push(next_state);
      }
    }
  }

  return -1;
}

int main() {
  std::ifstream file("input.txt");
  std::vector<std::string> input;
  std::string line;

  while (std::getline(file, line)) {
    input.push_back(line);
  }

  State initial_state = parse_input(input);
  int result = find_minimum_steps(initial_state);

  std::cout << "Minimum steps: " << result << std::endl;

  State initial_state2 = parse_input(input, true);
  int result2 = find_minimum_steps(initial_state2);

  std::cout << "Minimum steps with additional items: " << result2 << std::endl;

  return 0;
}
