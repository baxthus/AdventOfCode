#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#include <iostream>
#include <openssl/md5.h>
#include <queue>
#include <string>

std::string md5(const std::string &input) {
  unsigned char digest[MD5_DIGEST_LENGTH];
  MD5((unsigned char *)input.c_str(), input.length(), (unsigned char *)&digest);
  char mdString[33];
  for (int i = 0; i < 16; i++)
    sprintf(&mdString[i * 2], "%02x", (unsigned int)digest[i]);
  return std::string(mdString);
}

std::vector<bool> get_open_doors(const std::string &hash) {
  std::vector<bool> doors(4, false);
  for (int i = 0; i < 4; i++) {
    if (hash[i] >= 'b' && hash[i] <= 'f') {
      doors[i] = true;
    }
  }
  return doors;
}

std::pair<std::string, int> find_paths(const std::string &passcode) {
  std::queue<std::tuple<int, int, std::string>> q;
  q.push({0, 0, ""});
  int directions[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
  char dir_chars[4] = {'U', 'D', 'L', 'R'};
  std::string shortest_path;
  int longest_path_length = 0;

  while (!q.empty()) {
    auto [x, y, path] = q.front();
    q.pop();

    if (x == 3 && y == 3) {
      if (shortest_path.empty()) {
        shortest_path = path;
      }
      if (path.length() > longest_path_length) {
        longest_path_length = path.length();
      }
      continue;
    }

    std::string hash = md5(passcode + path);
    std::vector<bool> open_doors = get_open_doors(hash);

    for (int i = 0; i < 4; i++) {
      if (open_doors[i]) {
        int new_x = x + directions[i][0];
        int new_y = y + directions[i][1];
        if (new_x >= 0 && new_x < 4 && new_y >= 0 && new_y < 4) {
          q.push({new_x, new_y, path + dir_chars[i]});
        }
      }
    }
  }

  return {shortest_path, longest_path_length};
}

int main() {
  std::string passcode = "qtetzkpl";
  auto [shortest_path, longest_path_length] = find_paths(passcode);
  std::cout << "Shortest path: " << shortest_path << std::endl;
  std::cout << "Longest path length: " << longest_path_length << std::endl;
  return 0;
}
