#include <cmath>
#include <cstddef>
#include <fstream>
#include <iostream>
#include <map>
#include <regex>
#include <string>
#include <vector>

typedef std::map<std::string, std::vector<int>> Ingredients;
typedef std::vector<int> Amounts;

Ingredients parse_input(const std::string& filename) {
    Ingredients ingredients;
    std::ifstream file(filename);
    std::string line;
    std::regex regex("-?\\d+");

    while (getline(file, line)) {
        size_t pos = line.find(": ");
        std::string name = line.substr(0, pos);
        std::string properties_str = line.substr(pos + 2);
        std::vector<int> properties;
        std::sregex_iterator iter(properties_str.begin(), properties_str.end(), regex);
        std::sregex_iterator end;
        while (iter != end) {
            properties.push_back(std::stoi(iter->str()));
            ++iter;
        }
        ingredients[name] = properties;
    }

    return ingredients;
}

int calculate_score(const Ingredients& ingredients, const Amounts& amounts) {
    std::vector<int> totals(5, 0);

    int i = 0;
    for (const auto& ingredint : ingredients) {
        for (int j = 0; j < 5; ++j) {
            totals[j] += ingredint.second[j] * amounts[i];
        }
        ++i;
    }

    int score = 1;
    for (int i = 0; i < 4; ++i) {
        score *= std::max(0, totals[i]);
    }

    return score;
}

int calculate_score2(const Ingredients& ingredients, const Amounts& amounts) {
    std::vector<int> totals(5, 0);

    int i = 0;
    for (const auto& ingredint : ingredients) {
        for (int j = 0; j < 5; ++j) {
            totals[j] += ingredint.second[j] * amounts[i];
        }
        ++i;
    }

    if (totals[4] != 500) {
        return 0;
    }

    int score = 1;
    for (int i = 0; i < 4; ++i) {
        score *= std::max(0, totals[i]);
    }

    return score;
}

std::vector<Amounts> generate_combinations(int length, int total) {
    std::vector<Amounts> combinations;
    if (length == 1) {
        combinations.push_back({total});
        return combinations;
    }

    for (int i = 0; i <= total; ++i) {
        std::vector<Amounts> sub_combinations = generate_combinations(length - 1, total - i);
        for (auto& sub_combination : sub_combinations) {
            sub_combination.insert(sub_combination.begin(), i);
            combinations.push_back(sub_combination);
        }
    }
    return combinations;
}

int find_best_score(const Ingredients& ingredients) {
    int best_score = 0;
    for (const auto& combination : generate_combinations(ingredients.size(), 100)) {
        best_score = std::max(best_score, calculate_score(ingredients, combination));
    }
    return best_score;
}

int find_best_cookie(const Ingredients& ingredients) {
    int best_score = 0;
    for (const auto& combination : generate_combinations(ingredients.size(), 100)) {
        best_score = std::max(best_score, calculate_score2(ingredients, combination));
    }
    return best_score;
}

int main() {
    Ingredients ingredients = parse_input("input.txt");

    std::cout << "Part 1: " << find_best_score(ingredients) << std::endl;
    std::cout << "Part 2: " << find_best_cookie(ingredients) << std::endl;

    return 0;
}
