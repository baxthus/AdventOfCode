#include <fstream>
#include <iostream>
#include <map>
#include <regex>
#include <sstream>
#include <string>

using Aunts = std::map<int, std::map<std::string, int>>;
using MfcsamReading = std::map<std::string, int>;

Aunts parse_input(const std::string& filename) {
    Aunts aunts;
    std::ifstream file(filename);
    std::string line;
    std::regex regex(R"(Sue (\d+): (.*))");

    while (std::getline(file, line)) {
        std::smatch match;
        if (std::regex_search(line, match, regex)) {
            int sue_member = std::stoi(match[1].str());
            std::string attributes_str = match[2].str();
            std::map<std::string, int> aunt_data;
            std::istringstream attributes_stream(attributes_str);
            std::string attribute;

            while (std::getline(attributes_stream, attribute, ',')) {
                std::istringstream attribute_stream(attribute);
                std::string key;
                int value;
                if (std::getline(attribute_stream, key, ':')) {
                    attribute_stream >> value;
                    key.erase(0, key.find_first_not_of(" \t")); // Trim leading spaces
                    aunt_data[key] = value;
                }
            }
            aunts[sue_member] = aunt_data;
        }
    }

    return aunts;
}

int find_matching_sue(const Aunts& aunts, const MfcsamReading& mfcsamReading) {
    for (const auto& entry : aunts) {
        int sue = entry.first;
        const auto& attributes = entry.second;
        bool match = true;
        for (const auto& attribute : attributes) {
            if (mfcsamReading.at(attribute.first) != attribute.second) {
                match = false;
                break;
            }
        }
        if (match) {
            return sue;
        }
    }
    return -1;
}

bool match_attribute(const std::string& attr, int value, int mfcsamValue) {
    if (attr == "cats" || attr == "trees") {
        return value > mfcsamValue;
    } else if (attr == "pomeranians" || attr == "goldfish") {
        return value < mfcsamValue;
    } else {
        return value == mfcsamValue;
    }
}

int find_real_sue(const Aunts& aunts, const MfcsamReading& mfcsamReading) {
    for (const auto& entry : aunts) {
        int sue = entry.first;
        const auto& attributes = entry.second;
        bool match = true;
        for (const auto& attribute : attributes) {
            if (!match_attribute(attribute.first, attribute.second, mfcsamReading.at(attribute.first))) {
                match = false;
                break;
            }
        }
        if (match) {
            return sue;
        }
    }
    return -1;
}

int main() {
    MfcsamReading mfcsamReading = {
        {"children", 3},
        {"cats", 7},
        {"samoyeds", 2},
        {"pomeranians", 3},
        {"akitas", 0},
        {"vizslas", 0},
        {"goldfish", 5},
        {"trees", 3},
        {"cars", 2},
        {"perfumes", 1}
    };

    Aunts aunts = parse_input("input.txt");

    std::cout << "Part 1: " << find_matching_sue(aunts, mfcsamReading) << std::endl;
    std::cout << "Part 2: " << find_real_sue(aunts, mfcsamReading) << std::endl;

    return 0;
}
