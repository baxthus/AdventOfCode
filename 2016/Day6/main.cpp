#include <fstream>
#include <iostream>
#include <limits>
#include <string>
#include <unordered_map>
#include <vector>

std::string decode_message(const std::vector<std::string>& messages, bool find_least_frequent = false) {
    if (messages.empty()) return "";

    int num_columns = messages[0].size();
    std::vector<std::unordered_map<char, int>> frequency_maps(num_columns);

    for (const auto& message : messages) {
        for (int i = 0; i < num_columns; ++i) {
            ++frequency_maps[i][message[i]];
        }
    }

    std::string decoded_message;
    for (const auto& frequency_map : frequency_maps) {
        char selected_char = ' ';
        int selected_frequency = find_least_frequent ? std::numeric_limits<int>::max() : 0;

        for (const auto& [character, frequency] : frequency_map) {
            if ((find_least_frequent && frequency < selected_frequency) ||
                (!find_least_frequent && frequency > selected_frequency)) {
                selected_char = character;
                selected_frequency = frequency;
            }
        }

        decoded_message += selected_char;
    }

    return decoded_message;
}

int main() {
    std::ifstream input_file("input.txt");
    std::vector<std::string> messages;
    std::string line;

    while (std::getline(input_file, line)) {
        messages.push_back(line);
    }

    std::cout << "Part 1: " << decode_message(messages) << std::endl;
    std::cout << "Part 2: " << decode_message(messages, true) << std::endl;

    return 0;
}
