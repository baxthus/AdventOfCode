#include <cstdlib>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

bool is_safe(const std::vector<int>& levels) {
    if (levels.size() < 2) return true;

    bool increasing = levels[1] > levels[0];

    for (size_t i = 1; i < levels.size(); ++i) {
        int diff = levels[i] - levels[i - 1];
        if (increasing && diff <= 0) return false;
        if (!increasing && diff >= 0) return false;
        if (std::abs(diff) < 1 || std::abs(diff) > 3) return false;
    }

    return true;
}

bool is_safe_with_dampener(const std::vector<int>& levels) {
    if (is_safe(levels)) return true;

    for (size_t i = 0; i < levels.size(); i++) {
        std::vector<int> temp_levels = levels;
        temp_levels.erase(temp_levels.begin() + i);
        if (is_safe(temp_levels)) return true;
    }

    return false;
}

int main() {
    std::ifstream file("input.txt");
    std::string line;
    int safe_count = 0;
    int safe_count_with_dampener = 0;

    while (std::getline(file, line)) {
        std::istringstream iss(line);
        std::vector<int> levels;
        int level;

        while (iss >> level) {
            levels.push_back(level);
        }

        if (is_safe(levels)) safe_count++;
        if (is_safe_with_dampener(levels)) safe_count_with_dampener++;
    }

    std::cout << "Part 1: " << safe_count << std::endl;
    std::cout << "Part 2: " << safe_count_with_dampener << std::endl;

    return 0;
}
