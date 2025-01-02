#include <algorithm>
#include <cstddef>
#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

struct Room {
    std::string name;
    int sector_id;
    std::string checksum;
};

std::vector<Room> parse_input(const std::string& filename) {
    std::ifstream file(filename);
    std::vector<Room> rooms;
    std::string line;

    while (std::getline(file, line)) {
        size_t last_dash = line.find_last_of('-');
        size_t bracket_start = line.find('[');
        size_t bracket_end = line.find(']');

        std::string name = line.substr(0, last_dash);
        int sector_id = std::stoi(line.substr(last_dash + 1, bracket_start - last_dash - 1));
        std::string checksum = line.substr(bracket_start + 1, bracket_end - bracket_start - 1);

        rooms.push_back({name, sector_id, checksum});
    }

    return rooms;
}

std::string calculate_checksum(const std::string& name) {
    std::unordered_map<char, int> frequency;
    for (char c : name) {
        if (c != '-')
            frequency[c]++;
    }

    std::vector<std::pair<char, int>> freq_vec(frequency.begin(), frequency.end());
    std::sort(freq_vec.begin(), freq_vec.end(), [](const std::pair<char, int>& a, const std::pair<char, int>& b) {
        if (a.second == b.second)
            return a.first < b.first;
        return a.second > b.second;
    });

    std::string checksum;
    for (size_t i = 0; i < 5; i++) {
        checksum += freq_vec[i].first;
    }

    return checksum;
}

std::string decrypt_name(const std::string& name, int sector_id) {
    std::string decrypted_name;
    for (char c : name) {
        if (c == '-')
            decrypted_name += ' ';
        else {
            decrypted_name += (c - 'a' + sector_id) % 26 + 'a';
        }
    }
    return decrypted_name;
}

int main() {
    std::vector<Room> rooms = parse_input("input.txt");
    int sum_of_sector_ids = 0;
    int north_pole_sector_id = -1;

    for (const Room& room : rooms) {
        std::string checksum = calculate_checksum(room.name);
        if (checksum == room.checksum) {
            sum_of_sector_ids += room.sector_id;
            std::string decrypted_name = decrypt_name(room.name, room.sector_id);
            if (decrypted_name.find("northpole") != std::string::npos) {
                north_pole_sector_id = room.sector_id;
            }
        }
    }

    std::cout << "Part 1: " << sum_of_sector_ids << std::endl;
    std::cout << "Part 2: " << north_pole_sector_id << std::endl;

    return 0;
}
