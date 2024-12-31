#include <algorithm>
#include <fstream>
#include <iostream>
#include <limits>
#include <ostream>
#include <string>
#include <tuple>
#include <vector>

std::vector<std::tuple<std::string, int, int, int>> weapons = {
    {"Dagger", 8, 4, 0},
    {"Shortsword", 10, 5, 0},
    {"Warhammer", 25, 6, 0},
    {"Longsword", 40, 7, 0},
    {"Greataxe", 74, 8, 0}
};

std::vector<std::tuple<std::string, int, int, int>> armors = {
    {"No Armor", 0, 0, 0},
    {"Leather", 13, 0, 1},
    {"Chainmail", 31, 0, 2},
    {"Splintmail", 53, 0, 3},
    {"Bandedmail", 75, 0, 4},
    {"Platemail", 102, 0, 5}
};

std::vector<std::tuple<std::string, int, int, int>> rings = {
    {"No Ring", 0, 0, 0},
    {"Damage +1", 25, 1, 0},
    {"Damage +2", 50, 2, 0},
    {"Damage +3", 100, 3, 0},
    {"Defense +1", 20, 0, 1},
    {"Defense +2", 40, 0, 2},
    {"Defense +3", 80, 0, 3}
};

bool simulate_battle(int player_hp, int player_damage, int player_armor, int boss_hp, int boss_damage, int boss_armor) {
    while (true) {
        boss_hp -= std::max(1, player_damage - boss_armor);
        if (boss_hp <= 0) return true;
        player_hp -= std::max(1, boss_damage - player_armor);
        if (player_hp <= 0) return false;
    }
}

int find_least_gold_to_win(int boss_hp, int boss_damage, int boss_armor) {
    int min_gold = std::numeric_limits<int>::max();
    for (const auto& weapon : weapons) {
        for (const auto& armor : armors) {
            for (size_t i = 0; i < rings.size(); ++i) {
                for (size_t j = i; j < rings.size(); ++j) {
                    const auto& ring1 = rings[i];
                    const auto& ring2 = rings[j];
                    int gold = std::get<1>(weapon) + std::get<1>(armor) + std::get<1>(ring1) + std::get<1>(ring2);
                    int damage = std::get<2>(weapon) + std::get<2>(armor) + std::get<2>(ring1) + std::get<2>(ring2);
                    int defense = std::get<3>(weapon) + std::get<3>(armor) + std::get<3>(ring1) + std::get<3>(ring2);

                    if (simulate_battle(100, damage, defense, boss_hp, boss_damage, boss_armor)) {
                        min_gold = std::min(min_gold, gold);
                    }
                }
            }
        }
    }
    return min_gold;
}

int find_most_gold_to_lose(int boss_hp, int boss_damage, int boss_armor) {
    int max_gold = std::numeric_limits<int>::min();
    for (const auto& weapon : weapons) {
        for (const auto& armor : armors) {
            for (size_t i = 0; i < rings.size(); ++i) {
                for (size_t j = i; j < rings.size(); ++j) {
                    const auto& ring1 = rings[i];
                    const auto& ring2 = rings[j];

                    if (i == j && std::get<0>(ring1).find("No Ring") == std::string::npos) continue;

                    int gold = std::get<1>(weapon) + std::get<1>(armor) + std::get<1>(ring1) + std::get<1>(ring2);
                    int damage = std::get<2>(weapon) + std::get<2>(armor) + std::get<2>(ring1) + std::get<2>(ring2);
                    int defense = std::get<3>(weapon) + std::get<3>(armor) + std::get<3>(ring1) + std::get<3>(ring2);

                    if (!simulate_battle(100, damage, defense, boss_hp, boss_damage, boss_armor)) {
                        max_gold = std::max(max_gold, gold);
                    }
                }
            }
        }
    }
    return max_gold;
}

int main() {
    std::ifstream file("input.txt");
    std::string line;
    int boss_hp, boss_damage, boss_armor;

    std::getline(file, line);
    boss_hp = std::stoi(line.substr(line.find(": ") + 2));
    std::getline(file, line);
    boss_damage = std::stoi(line.substr(line.find(": ") + 2));
    std::getline(file, line);
    boss_armor = std::stoi(line.substr(line.find(": ") + 2));

    std::cout << "Part 1: " << find_least_gold_to_win(boss_hp, boss_damage, boss_armor) << std::endl;
    std::cout << "Part 2: " << find_most_gold_to_lose(boss_hp, boss_damage, boss_armor) << std::endl;

    return 0;
}
