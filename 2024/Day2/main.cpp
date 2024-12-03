#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

bool is_safe(const std::vector<int> &levels)
{
    if (levels.size() < 2)
        return true;

    int diff = levels[1] - levels[0];
    if (abs(diff) < 1 || abs(diff) > 3)
        return false;

    for (int i = 2; i < levels.size(); i++)
    {
        int new_diff = levels[i] - levels[i - 1];
        if (new_diff * diff <= 0 || abs(new_diff) < 1 || abs(new_diff) > 3)
            return false;
        diff = new_diff;
    }

    return true;
}

bool is_safe_with_dampener(const std::vector<int> &levels)
{
    if (levels.size() < 2)
        return true;

    if (is_safe(levels))
        return true;

    for (int i = 0; i < levels.size(); i++)
    {
        std::vector<int> dampened_levels = levels;
        dampened_levels.erase(dampened_levels.begin() + i);
        if (is_safe(dampened_levels))
            return true;
    }

    return false;
}

int main()
{
    std::ifstream file("input.txt");
    std::string line;
    int safe_count = 0;
    int safe_count_with_dampener = 0;

    while (std::getline(file, line))
    {
        std::istringstream iss(line);
        std::vector<int> levels;
        int level;

        while (iss >> level)
        {
            levels.push_back(level);
        }

        if (is_safe(levels))
            safe_count++;

        if (is_safe_with_dampener(levels))
            safe_count_with_dampener++;
    }

    std::cout << "Part 1: " << safe_count << std::endl;
    std::cout << "Part 2: " << safe_count_with_dampener << std::endl;

    return 0;
}