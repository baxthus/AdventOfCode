#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>
#include <cmath>
#include <unordered_map>

int calculate_total_distance(const std::string &input_text)
{
    std::vector<int> left_list, right_list;
    std::istringstream iss(input_text);
    std::string line;

    while (std::getline(iss, line))
    {
        if (!line.empty())
        {
            int left, right;
            std::istringstream line_stream(line);
            if (line_stream >> left >> right)
            {
                left_list.push_back(left);
                right_list.push_back(right);
            }
        }
    }

    std::sort(left_list.begin(), left_list.end());
    std::sort(right_list.begin(), right_list.end());

    int total_distance = 0;
    for (size_t i = 0; i < left_list.size(); i++)
    {
        total_distance += std::abs(left_list[i] - right_list[i]);
    }

    return total_distance;
}

int calculate_similarity_score(const std::string &input_text)
{
    std::vector<int> left_list, right_list;
    std::istringstream iss(input_text);
    std::string line;

    while (std::getline(iss, line))
    {
        if (!line.empty())
        {
            int left, right;
            std::istringstream line_stream(line);
            if (line_stream >> left >> right)
            {
                left_list.push_back(left);
                right_list.push_back(right);
            }
        }
    }

    std::unordered_map<int, int> right_counts;
    for (int num : right_list)
    {
        right_counts[num]++;
    }

    int similarity_score = 0;
    for (int num : left_list)
    {
        similarity_score += num * right_counts[num];
    }

    return similarity_score;
}

int main()
{
    std::ifstream file("input.txt");
    if (!file.is_open())
    {
        std::cerr << "Could not open the file!" << std::endl;
        return 1;
    }

    std::string input_text((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
    file.close();

    std::cout << "Part 1: " << calculate_total_distance(input_text) << std::endl;
    std::cout << "Part 2: " << calculate_similarity_score(input_text) << std::endl;

    return 0;
}