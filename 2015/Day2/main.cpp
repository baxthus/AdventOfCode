#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <algorithm>

int calculate_wrapping_paper(const std::string &dimensions)
{
    std::istringstream iss(dimensions);
    int l, w, h;
    char x;
    iss >> l >> x >> w >> x >> h;

    int surface_area = 2 * l * w + 2 * w * h + 2 * h * l;
    int smallest_side = std::min({l * w, w * h, h * l});
    return surface_area + smallest_side;
}

int total_wrapping_paper()
{
    int total = 0;
    std::ifstream file("input.txt");
    if (!file.is_open())
    {
        std::cerr << "Could not open the file!" << std::endl;
        return -1;
    }
    std::string line;

    while (std::getline(file, line))
    {
        total += calculate_wrapping_paper(line);
    }

    return total;
}

int calculate_ribbon(const std::string &dimensions)
{
    std::istringstream iss(dimensions);
    int l, w, h;
    char x;
    iss >> l >> x >> w >> x >> h;

    int volume = l * w * h;
    int smallest_perimeter = std::min({2 * l + 2 * w, 2 * w + 2 * h, 2 * h + 2 * l});
    return volume + smallest_perimeter;
}

int total_ribbon()
{
    int total = 0;
    std::ifstream file("input.txt");
    if (!file.is_open())
    {
        std::cerr << "Could not open the file!" << std::endl;
        return -1;
    }
    std::string line;

    while (std::getline(file, line))
    {
        total += calculate_ribbon(line);
    }

    return total;
}

int main()
{
    std::cout << "Part 1: " << total_wrapping_paper() << std::endl;
    std::cout << "Part 2: " << total_ribbon() << std::endl;
    return 0;
}