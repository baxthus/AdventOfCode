#include <algorithm>
#include <iostream>
#include <vector>

const int TARGET_PRESENTS = 34000000;

int find_lowest_house() {
    std::vector<int> house_presents(TARGET_PRESENTS / 10 + 1, 0);
    for (int elf = 1; elf < house_presents.size(); ++elf) {
        for (int house = elf; house < house_presents.size(); house += elf) {
            house_presents[house] += elf * 10;
        }
    }
    for (int house_number = 1; house_number < house_presents.size(); ++house_number) {
        if (house_presents[house_number] >= TARGET_PRESENTS) {
            return house_number;
        }
    }
    return -1; // No house found
}

int find_lowest_house2() {
    int max_houses = TARGET_PRESENTS / 11 + 1;
    std::vector<int> house_presents(max_houses, 0);
    for (int elf = 1; elf < house_presents.size(); ++elf) {
        for (int house = elf; house < std::min(elf * 50, static_cast<int>(house_presents.size())); house += elf) {
            house_presents[house] += elf * 11;
        }
    }
    for (int house_number = 1; house_number < house_presents.size(); ++house_number) {
        if (house_presents[house_number] >= TARGET_PRESENTS) {
            return house_number;
        }
    }
    return -1; // No house found
}

int main() {
    std::cout << "Part 1: " << find_lowest_house() << std::endl;
    std::cout << "Part 2: " << find_lowest_house2() << std::endl;

    return 0;
}
