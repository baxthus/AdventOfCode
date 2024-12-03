#include <fstream>
#include <iostream>
#include <iterator>
#include <regex>
#include <string>

long long solve_puzzle(const std::string& input) {
    std::regex pattern(R"(mul\((\d{1,3}),(\d{1,3})\))");
    std::smatch match;
    std::string::const_iterator search_start(input.cbegin());
    long long total = 0;

    while (std::regex_search(search_start, input.cend(), match, pattern)) {
        int x = std::stoi(match[1]);
        int y = std::stoi(match[2]);
        total += x * y;
        search_start = match.suffix().first;
    }

    return total;
}

long long solve_puzzle2(const std::string& input) {
    std::regex pattern(R"((?:do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)))");
    std::smatch match;
    std::string::const_iterator search_start(input.cbegin());
    long long total = 0;
    bool enabled = true;

    while (std::regex_search(search_start, input.cend(), match, pattern)) {
        if (match[0] == "do()") {
            enabled = true;
        } else if (match[0] == "don't()") {
            enabled = false;
        } else if (enabled && match[1].matched && match[2].matched) {
            int x = std::stoi(match[1]);
            int y = std::stoi(match[2]);
            total += x * y;
        }
        search_start = match.suffix().first;
    }

    return total;
}

int main() {
    std::ifstream file("input.txt");
    if (!file.is_open()) {
        std::cerr << "Failed to open file" << std::endl;
        return 1;;
    }

    std::string content((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
    file.close();

    std::cout << "Part 1: " << solve_puzzle(content) << std::endl;
    std::cout << "Part 2: " << solve_puzzle2(content) << std::endl;

    return 0;
}
