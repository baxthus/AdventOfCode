#include <cstdlib>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

bool is_valid_triangle(int a, int b, int c) {
    return (a + b > c) && (a + c > b) && (b + c > a);
}

std::vector<std::string> read_file(const std::string& filename) {
    std::ifstream input_file(filename);
    if (!input_file) {
        std::cerr << "Unable to open file" << std::endl;
        exit(1);
    }

    std::string line;
    std::vector<std::string> lines;

    while (std::getline(input_file, line)) {
        lines.push_back(line);
    }
    input_file.close();

    return lines;
}

int count_valid_triagles_row(const std::vector<std::vector<int>>& triangles) {
    int valid_triangles = 0;
    for (const auto& triangle : triangles) {
        if (is_valid_triangle(triangle[0], triangle[1], triangle[2])) {
            valid_triangles++;
        }
    }

    return valid_triangles;
}

int count_valid_triangles_column(const std::vector<std::vector<int>>& triangles) {
    int valid_triangles = 0;
    for (size_t i = 0; i < triangles.size(); i += 3) {
        if (i + 2 < triangles.size()) {
            for (size_t j = 0; j < 3; j++) {
                int a = triangles[i][j];
                int b = triangles[i + 1][j];
                int c = triangles[i + 2][j];
                if (is_valid_triangle(a, b, c)) {
                    valid_triangles++;
                }
            }
        }
    }

    return valid_triangles;
}

int main() {
    auto lines = read_file("input.txt");

    std::vector<std::vector<int>> triangles;
    for (const auto& line : lines) {
        std::istringstream iss(line);
        std::vector<int> sides(3);
        iss >> sides[0] >> sides[1] >> sides[2];
        triangles.push_back(sides);
    }

    std::cout << "Part 1: " << count_valid_triagles_row(triangles) << std::endl;
    std::cout << "Part 2: " << count_valid_triangles_column(triangles) << std::endl;

    return 0;
}
