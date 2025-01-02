#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

std::vector<std::string> read_file(const std::string& filename) {
    std::ifstream input_file(filename);
    if (!input_file) {
        std::cerr << "Unable to open file" << std::endl;
        exit(1);
    }

    std::vector<std::string> instructions;
    std::string line;
    while (std::getline(input_file, line)) {
        instructions.push_back(line);
    }
    input_file.close();

    return instructions;
}

std::unordered_map<int, std::pair<int, char>> keypad = {
    {'1', {0, 2}}, {'2', {1, 1}}, {'3', {1, 2}},
    {'4', {1, 3}}, {'5', {2, 0}}, {'6', {2, 1}},
    {'7', {2, 2}}, {'8', {2, 3}}, {'9', {2, 4}},
    {'A', {3, 1}}, {'B', {3, 2}}, {'C', {3, 3}},
    {'D', {4, 2}}
};

int main() {
    auto instructions = read_file("input.txt");

    std::unordered_map<int, std::pmr::unordered_map<int, char>> reverse_keypad;
    for (const auto& [key, value] : keypad) {
        reverse_keypad[value.first][value.second] = key;
    }

    int x1 = 1, y1 = 1; // Part 1
    int x2 = 2, y2 = 0; // Part 2

    std::string code = "";
    std::string code2 = "";

    for (const std::string& instruction : instructions) {
        for (char move : instruction) {
            int new_x2 = x2, new_y2 = y2;
            switch (move) {
                case 'U':
                    if (y1 > 0) y1--;
                    new_x2 = x2 - 1;
                    break;
                case 'D':
                    if (y1 < 2) y1++;
                    new_x2 = x2 + 1;
                    break;
                case 'L':
                    if (x1 > 0) x1--;
                    new_y2 = y2 - 1;
                    break;
                case 'R':
                    if (x1 < 2) x1++;
                    new_y2 = y2 + 1;
                    break;
            }
            if (reverse_keypad.count(new_x2) && reverse_keypad[new_x2].count(new_y2)) {
                x2 = new_x2;
                y2 = new_y2;
            }
        }
        code += std::to_string(y1 * 3 + x1 + 1);
        code2 += reverse_keypad[x2][y2];
    }

    std::cout << "Part 1: " << code << std::endl;
    std::cout << "Part 2: " << code2 << std::endl;

    return 0;
}
