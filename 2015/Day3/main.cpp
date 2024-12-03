#include <iostream>
#include <fstream>
#include <string>
#include <set>
#include <utility>

int count_houses_with_presents(const std::string &directions)
{
    int x = 0, y = 0;
    std::set<std::pair<int, int>> visited;
    visited.insert({x, y});

    for (char direction : directions)
    {
        switch (direction)
        {
        case '^':
            y++;
            break;
        case 'v':
            y--;
            break;
        case '>':
            x++;
            break;
        case '<':
            x--;
            break;
        }
        visited.insert({x, y});
    }

    return visited.size();
}

int count_houses_with_presents2(const std::string &directions)
{
    int santa_x = 0, santa_y = 0, robot_x = 0, robot_y = 0;
    std::set<std::pair<int, int>> visited;
    visited.insert({0, 0});

    for (size_t i = 0; i < directions.length(); ++i)
    {
        int &x = (i % 2 == 0) ? santa_x : robot_x;
        int &y = (i % 2 == 0) ? santa_y : robot_y;

        switch (directions[i])
        {
        case '^':
            y++;
            break;
        case 'v':
            y--;
            break;
        case '>':
            x++;
            break;
        case '<':
            x--;
            break;
        }
        visited.insert({x, y});
    }

    return visited.size();
}

int main()
{
    std::ifstream file("input.txt");
    if (!file.is_open())
    {
        std::cerr << "Could not open the file!" << std::endl;
        return 1;
    }

    std::string directions;
    std::getline(file, directions);
    file.close();

    std::cout << "Part 1: " << count_houses_with_presents(directions) << std::endl;
    std::cout << "Part 2: " << count_houses_with_presents2(directions) << std::endl;

    return 0;
}