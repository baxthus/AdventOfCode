#include <iostream>
#include <regex>
#include <string>
#include <vector>

struct Disc {
  int id;        // Disc number (k)
  int num_pos;   // Number of positions (N_k)
  int start_pos; // Starting position at time=0 (P_k)
};

bool check_time(int T, const std::vector<Disc> &discs) {
  for (const auto &disc : discs) {
    int time_at_disc = T + disc.id; // Time when capsule reaches this disc
    int position_at_time = (disc.start_pos + time_at_disc) % disc.num_pos;

    if (position_at_time != 0)
      return false; // Capsule bounces off this disc
  }
  return true; // Capsule passes through all discs
}

int find_first_valid_time(const std::vector<Disc> &discs) {
  int T = 0;
  while (true) {
    if (check_time(T, discs)) {
      return T;
    }
    T++;
  }
}

int main() {
  std::vector<Disc> discs;
  std::string line;

  std::regex pattern("Disc #(\\d+) has (\\d+) positions; at time=0, it is at "
                     "position (\\d+).");
  std::smatch matches;

  int max_id = 0;

  while (std::getline(std::cin, line)) {
    if (line.empty())
      continue;

    if (std::regex_match(line, matches, pattern)) {
      if (matches.size() == 4) {
        int id = std::stoi(matches[1].str());
        int num_pos = std::stoi(matches[2].str());
        int start_pos = std::stoi(matches[3].str());
        discs.push_back({id, num_pos, start_pos});
        if (id > max_id)
          max_id = id;
      } else {
        std::cerr << "Error: Regex match failed to capture all groups."
                  << std::endl;
        return 1;
      }
    } else {
      std::cerr << "Error: Regex match failed for line: " << line << std::endl;
      return 1;
    }
  }

  if (discs.empty()) {
    std::cerr << "Error: No discs found in input." << std::endl;
    return 1;
  }

  int T1 = find_first_valid_time(discs);
  if (T1 != -1) {
    std::cout << "First time the capsule passes through all discs: " << T1
              << std::endl;
  }

  int new_disc_id = max_id + 1;
  int new_disc_num_pos = 11;
  int new_disc_start_pos = 0;
  discs.push_back({new_disc_id, new_disc_num_pos, new_disc_start_pos});

  int T2 = find_first_valid_time(discs);
  if (T2 != -1) {
    std::cout << "First time the capsule passes through all discs (with new "
                 "disc): "
              << T2 << std::endl;
  }

  return 0;
}
