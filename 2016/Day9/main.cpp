#include <cstddef>
#include <fstream>
#include <iostream>
#include <string>

long long decompressed_length(const std::string& input) {
    long long length = 0;
    size_t i = 0;

    while (i < input.size()) {
        if (input[i] == '(') {
            // find the end of the marker
            size_t marker_end = input.find(')', i);
            if (marker_end == std::string::npos) {
                std::cerr << "Invalid marker at position " << i << std::endl;
                return -1;
            }

            // parse the marker
            std::string marker = input.substr(i + 1, marker_end - i - 1);
            size_t x_pos = marker.find('x');
            if (x_pos == std::string::npos) {
                std::cerr << "Invalid marker at position " << i << std::endl;
                return -1;
            }

            int chars_to_repeat = std::stoi(marker.substr(0, x_pos));
            int repeat_count = std::stoi(marker.substr(x_pos + 1));

            // move the index past the marker
            i = marker_end + 1;

            // add the length of the repeated string
            length += chars_to_repeat * repeat_count;

            // move the index past the repeated string
            i += chars_to_repeat;
        } else if (!std::isspace(input[i])) {
            // regular character, just count it
            length++;
            i++;
        } else {
            // skip whitespace
            i++;
        }
    }

    return length;
}

long long decompressed_length_v2(const std::string& input, size_t start = 0, size_t end = std::string::npos) {
    long long length = 0;
    size_t i = start;

    if (end == std::string::npos) {
        end = input.size();
    }

    while (i < end) {
        if (input[i] == '(') {
            // find the end of the marker
            size_t marker_end = input.find(')', i);
            if (marker_end == std::string::npos) {
                std::cerr << "Invalid marker at position " << i << std::endl;
                return -1;
            }

            // parse the marker
            std::string marker = input.substr(i + 1, marker_end - i - 1);
            size_t x_pos = marker.find('x');
            if (x_pos == std::string::npos) {
                std::cerr << "Invalid marker at position " << i << std::endl;
                return -1;
            }

            int chars_to_repeat = std::stoi(marker.substr(0, x_pos));
            int repeat_count = std::stoi(marker.substr(x_pos + 1));

            // move the index past the marker
            i = marker_end + 1;

            // recursively calculate the length of the repeated string
            long long repeated_length = decompressed_length_v2(input, i, i + chars_to_repeat);
            length += repeated_length * repeat_count;

            // move the index past the repeated string
            i += chars_to_repeat;
        } else if (!std::isspace(input[i])) {
            // regular character, just count it
            length++;
            i++;
        } else {
            // skip whitespace
            i++;
        }
    }

    return length;
}

int main() {
    std::ifstream input_file("input.txt");
    if (!input_file) {
        std::cerr << "Could not open input.txt" << std::endl;
        return 1;
    }

    std::string input;
    std::getline(input_file, input, '\0'); // read the entire file

    std::cout << "Part 1: " << decompressed_length(input) << std::endl;
    std::cout << "Part 2: " << decompressed_length_v2(input) << std::endl;

    return 0;
}
