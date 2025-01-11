#include <cstddef>
#include <fstream>
#include <iostream>
#include <regex>
#include <string>
#include <vector>

bool is_nice_string(const std::string& s) {
    const std::string vowels = "aeiou";
    const std::vector<std::string> disallowed = {"ab", "cd", "pq", "xy"};
    int vowel_count = 0;
    bool has_double_letter = false;
    bool contains_disallowed = false;

    for (size_t i = 0; i < s.size(); ++i) {
        if (vowels.find(s[i]) != std::string::npos) {
            ++vowel_count;
        }
        if (i > 0 && s[i] == s[i - 1]) {
            has_double_letter = true;
        }
    }

    for (const std::string& dis : disallowed) {
        if (s.find(dis) != std::string::npos) {
            contains_disallowed = true;
            break;
        }
    }

    return vowel_count >= 3 && has_double_letter && !contains_disallowed;
}

bool is_nice_string2(const std::string& s) {
    std::regex repeating_pair(R"((..).*\1)");
    std::regex repeating_letter_with_one_between(R"((.).\1)");

    bool has_repeating_pair = std::regex_search(s, repeating_pair);
    bool has_repeating_letter_with_one_between = std::regex_search(s, repeating_letter_with_one_between);

    return has_repeating_pair && has_repeating_letter_with_one_between;
}

int count_nice_strings(const std::vector<std::string>& strings, bool (*function)(const std::string&)) {
    int count = 0;
    for (const std::string& s : strings) {
        if (function(s)) {
            ++count;
        }
    }
    return count;
}

int main() {
    std::ifstream file("input.txt");
    std::vector<std::string> strings;
    std::string line;

    while (std::getline(file, line)) {
        strings.push_back(line);
    }

    std::cout << "Part 1: " << count_nice_strings(strings, is_nice_string) << std::endl;
    std::cout << "Part 2: " << count_nice_strings(strings, is_nice_string2) << std::endl;

    return 0;
}
