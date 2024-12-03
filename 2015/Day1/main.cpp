#include <iostream>
#include <fstream>
#include <string>

int calculate_final_floor(const std::string &instructions)
{
    int floor = 0;
    for (char c : instructions)
    {
        if (c == '(')
            floor++;
        else if (c == ')')
            floor--;
    }
    return floor;
}

int find_basement_entry(const std::string &instructions)
{
    int floor = 0;
    for (int position = 0; position < instructions.length(); position++)
    {
        if (instructions[position] == '(')
            floor++;
        else if (instructions[position] == ')')
            floor--;

        if (floor == -1)
            return position + 1;
    }
    return -1;
}

int main()
{
    std::ifstream file("input.txt");
    if (!file.is_open())
    {
        std::cerr << "Could not open the file!" << std::endl;
        return 1;
    }

    std::string instructions;
    std::getline(file, instructions);
    file.close();

    std::cout << "Part 1: " << calculate_final_floor(instructions) << std::endl;
    std::cout << "Part 2: " << find_basement_entry(instructions) << std::endl;

    return 0;
}