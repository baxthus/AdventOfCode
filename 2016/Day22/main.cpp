#include <iostream>
#include <queue>
#include <regex>
#include <set>
#include <string>
#include <vector>

struct Node {
  int x, y;
  int size, used, avail;

  Node(int x, int y, int size, int used, int avail)
      : x(x), y(y), size(size), used(used), avail(avail) {}
};

void printGrid(const std::vector<Node> &nodes, int maxX, int maxY, int emptyX,
               int emptyY, int goalX) {
  std::vector<std::vector<char>> grid(maxY + 1,
                                      std::vector<char>(maxX + 1, '.'));

  for (const auto &node : nodes) {
    if (node.used > 100)
      grid[node.y][node.x] = '#';
  }

  grid[emptyY][emptyX] = '_';
  grid[0][0] = 'O';
  grid[0][goalX] = 'G';

  std::cout << "Grid visualization:" << std::endl;
  for (int y = 0; y <= maxY; y++) {
    for (int x = 0; x <= maxX; x++) {
      std::cout << grid[y][x] << ' ';
    }
    std::cout << std::endl;
  }
}

struct State {
  int emptyX, emptyY;
  int goalX, goalY;
  int steps;

  State(int ex, int ey, int gx, int gy, int s)
      : emptyX(ex), emptyY(ey), goalX(gx), goalY(gy), steps(s) {}

  bool operator<(const State &other) const {
    if (emptyX != other.emptyX)
      return emptyX < other.emptyX;
    if (emptyY != other.emptyY)
      return emptyY < other.emptyY;
    if (goalX != other.goalX)
      return goalX < other.goalX;
    return goalY < other.goalY;
  }
};

int solvePart2(const std::vector<Node> &nodes) {
  int maxX = 0, maxY = 0;
  for (const auto &node : nodes) {
    maxX = std::max(maxX, node.x);
    maxY = std::max(maxY, node.y);
  }

  int emptyX = -1, emptyY = -1;
  for (const auto &node : nodes) {
    if (node.used == 0) {
      emptyX = node.x;
      emptyY = node.y;
      break;
    }
  }

  int goalX = maxX;
  int goalY = 0;

  std::vector<std::vector<bool>> viableNodes(maxY + 1,
                                             std::vector<bool>(maxX + 1, true));
  for (const auto &node : nodes) {
    if (node.used > 100)
      viableNodes[node.y][node.x] = false;
  }

  printGrid(nodes, maxX, maxY, emptyX, emptyY, goalX);

  std::queue<State> q;
  std::set<State> visited;

  State start(emptyX, emptyY, goalX, goalY, 0);
  q.push(start);
  visited.insert(start);

  const int dx[] = {0, 1, 0, -1};
  const int dy[] = {-1, 0, 1, 0};

  while (!q.empty()) {
    State current = q.front();
    q.pop();

    if (current.goalX == 0 && current.goalY == 0)
      return current.steps;

    for (int dir = 0; dir < 4; dir++) {
      int newEmptyX = current.emptyX + dx[dir];
      int newEmptyY = current.emptyY + dy[dir];

      if (newEmptyX >= 0 && newEmptyX <= maxX && newEmptyY >= 0 &&
          newEmptyY <= maxY && viableNodes[newEmptyY][newEmptyX]) {
        int newGoalX = current.goalX;
        int newGoalY = current.goalY;

        if (newEmptyX == current.goalX && newEmptyY == current.goalY) {
          newGoalX = current.emptyX;
          newGoalY = current.emptyY;
        }

        State newState(newEmptyX, newEmptyY, newGoalX, newGoalY,
                       current.steps + 1);

        if (visited.find(newState) == visited.end()) {
          visited.insert(newState);
          q.push(newState);
        }
      }
    }
  }

  return -1;
}

int main() {
  std::vector<Node> nodes;
  std::string line;

  std::getline(std::cin, line);
  std::getline(std::cin, line);

  std::regex pattern(R"(node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+\d+%)");
  std::smatch matches;

  while (std::getline(std::cin, line)) {
    if (std::regex_search(line, matches, pattern)) {
      int x = std::stoi(matches[1]);
      int y = std::stoi(matches[2]);
      int size = std::stoi(matches[3]);
      int used = std::stoi(matches[4]);
      int avail = std::stoi(matches[5]);

      nodes.emplace_back(x, y, size, used, avail);
    }
  }

  int viablePairs = 0;
  for (size_t i = 0; i < nodes.size(); i++) {
    for (size_t j = 0; j < nodes.size(); j++) {
      if (i != j && nodes[i].used > 0 && nodes[i].used <= nodes[j].avail) {
        viablePairs++;
      }
    }
  }

  std::cout << "Number of viable pairs: " << viablePairs << std::endl;

  int minSteps = solvePart2(nodes);
  std::cout << "Minimum steps required: " << minSteps << std::endl;

  return 0;
}