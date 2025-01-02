#include <cstddef>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_set>
#include <vector>

enum Direction { NORTH, EAST, SOUTH, WEST };

struct Position {
    int x;
    int y;

    bool operator==(const Position& other) const {
        return x == other.x && y == other.y;
    }
};

namespace std {
    template <>
    struct hash<Position> {
        std::size_t operator()(const Position& pos) const {
            return std::hash<int>()(pos.x) ^ std::hash<int>()(pos.y) << 1;
        }
    };
}

std::string trim(const std::string& str) {
    size_t first = str.find_first_not_of(' ');
    if (first == std::string::npos) return "";
    size_t last = str.find_last_not_of(' ');
    return str.substr(first, (last - first + 1));
}

std::vector<std::string> read_file(const std::string& filename) {
    std::ifstream input_file(filename);
    std::string line;
    if (input_file.is_open()) {
        std::getline(input_file, line);
        input_file.close();
    }

    std::stringstream ss(line);
    std::string instruction;
    std::vector<std::string> instructions;

    while (std::getline(ss, instruction, ',')) {
        instruction = trim(instruction);
        if (!instruction.empty())
            instructions.push_back(instruction);
    }

    return instructions;
}

int main() {
    auto instructions = read_file("input.txt");

    Position pos = {0, 0};
    Direction dir = NORTH;
    std::unordered_set<Position> visited;
    visited.insert(pos);
    bool found = false;
    int first_revisited_distance = 0;

    for (const auto& instr : instructions) {
        char turn = instr[0];
        int steps = std::stoi(instr.substr(1));

        if (turn == 'L') {
            dir = static_cast<Direction>((dir + 3) % 4); // Left
        } else if (turn == 'R') {
            dir = static_cast<Direction>((dir + 1) % 4); // Right
        }

        for (int i = 0; i < steps; ++i) {
            switch (dir) {
                case NORTH:
                    pos.y += 1;
                    break;
                case EAST:
                    pos.x += 1;
                    break;
                case SOUTH:
                    pos.y -= 1;
                    break;
                case WEST:
                    pos.x -= 1;
                    break;
            }

            if (visited.find(pos) != visited.end() && !found) {
                first_revisited_distance = std::abs(pos.x) + std::abs(pos.y);
                found = true;
            }
            visited.insert(pos);
        }
    }

    int distance = std::abs(pos.x) + std::abs(pos.y);
    std::cout << "Part 1: " << distance << std::endl;
    if (found)
        std::cout << "Part 2: " << first_revisited_distance << std::endl;
    else
        std::cout << "Part 2: No revisited position found" << std::endl;

    return 0;
}
