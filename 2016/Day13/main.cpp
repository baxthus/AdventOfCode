#include <bitset>
#include <iostream>
#include <queue>
#include <set>

const int FAVORITE_NUMBER = 1364;

bool is_wall(int x, int y) {
  int formula = x * x + 3 * x + 2 * x * y + y + y * y + FAVORITE_NUMBER;
  int bit_count = std::bitset<32>(formula).count();
  return bit_count % 2 != 0;
}

int bfs(int start_x, int start_y, int target_x, int target_y,
        int max_steps = 0) {
  std::queue<std::tuple<int, int, int>> q;
  std::set<std::pair<int, int>> visited;
  q.push({start_x, start_y, 0});
  visited.insert({start_x, start_y});

  while (!q.empty()) {
    auto [x, y, steps] = q.front();
    q.pop();

    if (max_steps != 0 && steps >= max_steps)
      continue;

    if (max_steps == 0 && x == target_x && y == target_y)
      return steps;

    std::vector<std::pair<int, int>> directions = {
        {1, 0}, {-1, 0}, {0, 1}, {0, -1}};
    for (auto [dx, dy] : directions) {
      int new_x = x + dx;
      int new_y = y + dy;

      if (new_x >= 0 && new_y >= 0 && !is_wall(new_x, new_y) &&
          visited.find({new_x, new_y}) == visited.end()) {
        q.push({new_x, new_y, steps + 1});
        visited.insert({new_x, new_y});
      }
    }
  }

  if (max_steps != 0)
    return visited.size();

  return -1; // No path found
}

int main() {
  int start_x = 1, start_y = 1;
  int target_x = 31, target_y = 39;

  std::cout << "Part 1: " << bfs(start_x, start_y, target_x, target_y)
            << std::endl;

  std::cout << "Part 2: " << bfs(start_x, start_y, target_x, target_y, 50)
            << std::endl;

  return 0;
}
