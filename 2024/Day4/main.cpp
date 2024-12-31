#include <fstream>
#include <iostream>
#include <string>
#include <vector>
int count_xmas(const std::vector<std::string>& grid) {
    int count = 0;
    int rows = grid.size();
    int cols = grid[0].size();

    auto check_xmas = [&](int r, int c, int dr, int dc) {
        if (r + 3*dr < 0 || r + 3*dr >= rows || c + 3*dc < 0 || c + 3*dc >= cols)
            return false;
        return grid[r][c] == 'X' && grid[r+dr][c+dc] == 'M' &&
               grid[r+2*dr][c+2*dc] == 'A' && grid[r+3*dr][c+3*dc] == 'S';
    };

    for (int r = 0; r < rows; ++r) {
        for (int c = 0; c < cols; ++c) {
            count += check_xmas(r, c, 0, 1);  // right
            count += check_xmas(r, c, 1, 0);  // down
            count += check_xmas(r, c, 1, 1);  // diagonal down-right
            count += check_xmas(r, c, 1, -1); // diagonal down-left
            count += check_xmas(r, c, 0, -1); // left
            count += check_xmas(r, c, -1, 0); // up
            count += check_xmas(r, c, -1, 1); // diagonal up-right
            count += check_xmas(r, c, -1, -1); // diagonal up-left
        }
    }

    return count;
}

int count_xmas2(const std::vector<std::string>& grid) {
    int count = 0;
    int rows = grid.size();
    int cols = grid[0].size();

    auto check_xmas = [&](int r, int c, int dr1, int dc1, int dr2, int dc2) {
        if (r + dr1 < 0 || r + dr1 >= rows || c + dc1 < 0 || c + dc1 >= cols ||
            r + dr2 < 0 || r + dr2 >= rows || c + dc2 < 0 || c + dc2 >= cols)
            return false;
        return (grid[r][c] == 'M' && grid[r+dr1][c+dc1] == 'A' && grid[r+dr2][c+dc2] == 'S') ||
               (grid[r][c] == 'S' && grid[r+dr1][c+dc1] == 'A' && grid[r+dr2][c+dc2] == 'M');
    };

    for (int r = 0; r < rows; ++r) {
        for (int c = 0; c < cols; ++c) {
            count += check_xmas(r, c, 1, -1, 2, -2) && check_xmas(r, c, 1, 1, 2, 2);
            count += check_xmas(r, c, 1, -1, 2, -2) && check_xmas(r+2, c-2, -1, 1, -2, 2);
            count += check_xmas(r, c, 1, 1, 2, 2) && check_xmas(r+2, c+2, -1, -1, -2, -2);
            count += check_xmas(r+2, c-2, -1, 1, -2, 2) && check_xmas(r+2, c+2, -1, -1, -2, -2);
        }
    }

    return count;
}

int main() {
    std::ifstream file("input.txt");
    std::vector<std::string> grid;
    std::string line;

    while (std::getline(file, line)) {
        grid.push_back(line);
    }

    int result = count_xmas(grid);
    int result2 = count_xmas2(grid);

    std::cout << "Part 1: " << result << std::endl;
    std::cout << "Part 2: " << result2 << std::endl;

    return 0;
}
