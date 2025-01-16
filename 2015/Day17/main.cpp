#include <fstream>
#include <iostream>
#include <map>
#include <numeric>
#include <string>
#include <vector>

void combinations(const std::vector<int> &elements, int r, int start,
                  std::vector<int> &current,
                  std::vector<std::vector<int>> &result) {
  if (r == 0) {
    result.push_back(current);
    return;
  }

  for (int i = start; i <= elements.size() - r; ++i) {
    current.push_back(elements[i]);
    combinations(elements, r - 1, i + 1, current, result);
    current.pop_back();
  }
}

int count_eggnog_combinations(const std::vector<int> &containers, int target) {
  int count = 0;
  for (int r = 1; r <= containers.size(); ++r) {
    std::vector<std::vector<int>> result;
    std::vector<int> current;
    combinations(containers, r, 0, current, result);
    for (const auto &combo : result) {
      if (std::accumulate(combo.begin(), combo.end(), 0) == target) {
        count++;
      }
    }
  }
  return count;
}

std::map<std::string, int>
find_min_containers_and_combinations(const std::vector<int> &containers,
                                     int target) {
  for (int r = 1; r <= containers.size(); ++r) {
    int count = 0;
    std::vector<std::vector<int>> result;
    std::vector<int> current;
    combinations(containers, r, 0, current, result);
    for (const auto &combo : result) {
      if (std::accumulate(combo.begin(), combo.end(), 0) == target) {
        count++;
      }
    }
    if (count > 0) {
      return {{"min_containers", r}, {"combinations", count}};
    }
  }
  return {{"min_containers", 0}, {"combinations", 0}};
}

int main() {
  std::ifstream file("input.txt");
  std::vector<int> containers;
  std::string line;
  while (std::getline(file, line)) {
    containers.push_back(std::stoi(line));
  }

  int target_volume = 150;

  std::cout << "Part 1: "
            << count_eggnog_combinations(containers, target_volume)
            << std::endl;
  std::cout << "Part 2: "
            << find_min_containers_and_combinations(
                   containers, target_volume)["combinations"]
            << std::endl;
}
