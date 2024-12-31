#include <fstream>
#include <iostream>
#include <iterator>
#include <regex>
#include <string>

long long solve_part1(const std::string& input) {
    long long total = 0;
    std::regex pattern(R"(mul\((\d{1,3}),(\d{1,3})\))");
    std::smatch matches;

    std::string::const_iterator search_start(input.cbegin());
    while (std::regex_search(search_start, input.cend(), matches, pattern)) {
        int x = std::stoi(matches[1]);
        int y = std::stoi(matches[2]);
        total += x * y;
        search_start = matches.suffix().first;
    }

    return total;
}

long long solve_part2(const std::string& input) {
    long long total = 0;
    bool enabled = true;
    std::regex pattern(R"((do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)))");
    std::smatch matches;

    std::string::const_iterator search_start(input.cbegin());
    while (std::regex_search(search_start, input.cend(), matches, pattern)) {
        std::string instruction = matches[1];
        if (instruction == "do()") {
            enabled = true;
        } else if (instruction == "don't()") {
            enabled = false;
        } else if (enabled && instruction.substr(0, 3) == "mul") {
            int x = std::stoi(matches[2]);
            int y = std::stoi(matches[3]);
            total += x * y;
        }
        search_start = matches.suffix().first;
    }

    return total;
}

int main() {
    std::ifstream file("input.txt");
    std::string input((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
    file.close();

    long long result = solve_part1(input);
    std::cout << "Part 1: " << result << std::endl;

    long long result2 = solve_part2(input);
    std::cout << "Part 2: " << result2 << std::endl;

    return 0;
}
