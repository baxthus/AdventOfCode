#include <algorithm>
#include <fstream>
#include <iostream>
#include <iterator>
#include <numeric>
#include <sstream>
#include <string>
#include <vector>

int process_light(const std::vector<std::string> &instructions) {
  std::vector<std::vector<bool>> grid(1000, std::vector<bool>(1000, false));

  for (const auto &instruction : instructions) {
    std::istringstream iss(instruction);
    std::vector<std::string> parts((std::istream_iterator<std::string>(iss)),
                                   std::istream_iterator<std::string>());

    if (parts[0] == "turn") {
      std::string action = parts[1];
      std::vector<int> start, end;
      std::stringstream ss1(parts[2]), ss2(parts[4]);
      std::string temp;
      while (std::getline(ss1, temp, ','))
        start.push_back(std::stoi(temp));
      while (std::getline(ss2, temp, ','))
        end.push_back(std::stoi(temp));

      for (int i = start[0]; i <= end[0]; ++i) {
        for (int j = start[1]; j <= end[1]; ++j) {
          grid[i][j] = (action == "on");
        }
      }
    } else if (parts[0] == "toggle") {
      std::vector<int> start, end;
      std::stringstream ss1(parts[1]), ss2(parts[3]);
      std::string temp;
      while (std::getline(ss1, temp, ','))
        start.push_back(std::stoi(temp));
      while (std::getline(ss2, temp, ','))
        end.push_back(std::stoi(temp));

      for (int i = start[0]; i <= end[0]; ++i) {
        for (int j = start[1]; j <= end[1]; ++j) {
          grid[i][j] = !grid[i][j];
        }
      }
    }
  }

  int count = 0;
  for (const auto &row : grid) {
    count +=
        std::count_if(row.begin(), row.end(), [](bool light) { return light; });
  }

  return count;
}

int process_light_brightness(const std::vector<std::string>& instructions) {
    std::vector<std::vector<int>> grid(1000, std::vector<int>(1000, 0));

    for (const auto& instruction : instructions) {
        std::istringstream iss(instruction);
        std::vector<std::string> parts((std::istream_iterator<std::string>(iss)),
                                       std::istream_iterator<std::string>());

        if (parts[0] == "turn") {
            std::string action = parts[1];
            std::vector<int> start, end;
            std::stringstream ss1(parts[2]), ss2(parts[4]);
            std::string temp;
            while (std::getline(ss1, temp, ','))
                start.push_back(std::stoi(temp));
            while (std::getline(ss2, temp, ','))
                end.push_back(std::stoi(temp));

            for (int i = start[0]; i <= end[0]; ++i) {
                for (int j = start[1]; j <= end[1]; ++j) {
                    if (action == "on") {
                        grid[i][j]++;
                    } else {
                        grid[i][j] = std::max(0, grid[i][j] - 1);
                    }
                }
            }
        } else if (parts[0] == "toggle") {
            std::vector<int> start, end;
            std::stringstream ss1(parts[1]), ss2(parts[3]);
            std::string temp;
            while (std::getline(ss1, temp, ','))
                start.push_back(std::stoi(temp));
            while (std::getline(ss2, temp, ','))
                end.push_back(std::stoi(temp));

            for (int i = start[0]; i <= end[0]; ++i) {
                for (int j = start[1]; j <= end[1]; ++j) {
                    grid[i][j] += 2;
                }
            }
        }
    }

    int total_brightness = 0;
    for (const auto& row : grid) {
        total_brightness += std::accumulate(row.begin(), row.end(), 0);
    }

    return total_brightness;
}

int main() {
    std::ifstream file("input.txt");
    std::vector<std::string> instructions;
    std::string line;

    while (std::getline(file, line)) {
        instructions.push_back(line);
    }

    std::cout << "Part 1: " << process_light(instructions) << std::endl;
    std::cout << "Part 2: " << process_light_brightness(instructions) << std::endl;

    return 0;
}
