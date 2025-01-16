#include <algorithm>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

typedef std::vector<std::vector<char>> Grid;

Grid read_input(const std::string &filepath) {
  std::ifstream file(filepath);
  Grid grid;
  std::string line;
  while (std::getline(file, line)) {
    grid.push_back(std::vector<char>(line.begin(), line.end()));
  }
  return grid;
}

int count_on_neighbors(const Grid &grid, int x, int y) {
  int count = 0;
  for (int dx = -1; dx <= 1; ++dx) {
    for (int dy = -1; dy <= 1; ++dy) {
      if (dx == 0 && dy == 0)
        continue;
      int nx = x + dx, ny = y + dy;
      if (nx >= 0 && nx < grid.size() && ny >= 0 && ny < grid[0].size()) {
        count += grid[nx][ny] == '#';
      }
    }
  }
  return count;
}

Grid step(const Grid &grid, bool corners = false) {
  Grid new_grid = grid;
  for (int x = 0; x < grid.size(); ++x) {
    for (int y = 0; y < grid[0].size(); ++y) {
      int count = count_on_neighbors(grid, x, y);
      if (grid[x][y] == '#') {
        new_grid[x][y] = count == 2 || count == 3 ? '#' : '.';
      } else {
        new_grid[x][y] = count == 3 ? '#' : '.';
      }
    }
  }

  if (corners) {
    new_grid[0][0] = new_grid[0][new_grid[0].size() - 1] =
        new_grid[grid.size() - 1][0] =
            new_grid[grid.size() - 1][grid[0].size() - 1] = '#';
  }

  return new_grid;
}

int count_on_lights(const Grid &grid) {
  int count = 0;
  for (const auto &row : grid) {
    count +=
        std::count_if(row.begin(), row.end(), [](char c) { return c == '#'; });
  }
  return count;
}

int main() {
  Grid grid = read_input("input.txt");
  for (int i = 0; i < 100; ++i) {
    grid = step(grid);
  }
  std::cout << "Part 1: " << count_on_lights(grid) << std::endl;

  grid = read_input("input.txt");
  grid[0][0] = grid[0][grid[0].size() - 1] = grid[grid.size() - 1][0] =
      grid[grid.size() - 1][grid[0].size() - 1] = '#';
  for (int i = 0; i < 100; ++i) {
    grid = step(grid, true);
  }
  std::cout << "Part 2: " << count_on_lights(grid) << std::endl;
}
