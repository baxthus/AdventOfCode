#include <algorithm>
#include <fstream>
#include <iostream>
#include <unordered_map>
#include <vector>

int main() {
    std::ifstream file("../input.txt");
    std::vector<int> left, right;
    int a, b;

    while (file >> a >> b) {
        left.push_back(a);
        right.push_back(b);
    }

    std::sort(left.begin(), left.end());
    std::sort(right.begin(), right.end());

    long long total_distance = 0;
    for (size_t i = 0; i < left.size(); i++) {
        total_distance += std::abs(left[i] - right[i]);
    }

    std::cout << "Part 1: " << total_distance << std::endl;

    std::unordered_map<int, int> right_counts;
    for (int num : right) {
        right_counts[num]++;
    }

    long long similiatiry_score = 0;
    for (int num : left) {
        similiatiry_score += num * right_counts[num];
    }

    std::cout << "Part 2: " << similiatiry_score << std::endl;

    return 0;
}
