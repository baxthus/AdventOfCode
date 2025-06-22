#include <algorithm>
#include <iostream>
#include <vector>

typedef std::vector<std::pair<unsigned int, unsigned int>> RangeList;

unsigned long long part1(RangeList ranges) {
  unsigned long long lowest_allowed_ip = 0;

  for (const auto &range : ranges) {
    if (lowest_allowed_ip < range.first)
      break;

    if (lowest_allowed_ip <= range.second)
      lowest_allowed_ip = (unsigned long long)range.second + 1;
  }

  return lowest_allowed_ip;
}

unsigned long long part2(RangeList ranges) {
  if (ranges.empty())
    return 0;

  unsigned long long total_blocked_count = 0;
  unsigned int merged_start = ranges[0].first;
  unsigned int merged_end = ranges[0].second;

  for (size_t i = 1; i < ranges.size(); i++) {
    if (ranges[i].first <= (unsigned long long)merged_end + 1) {
      if (ranges[i].second > merged_end) {
        merged_end = ranges[i].second;
      }
    } else {
      total_blocked_count += (unsigned long long)merged_end - merged_start + 1;
      merged_start = ranges[i].first;
      merged_end = ranges[i].second;
    }
  }
  total_blocked_count += (unsigned long long)merged_end - merged_start + 1;

  const unsigned long long total_ips = 4294967296ULL; // 2^32
  return total_ips - total_blocked_count;
}

int main() {
  RangeList ranges;

  unsigned int start, end;
  char dash;
  while (std::cin >> start >> dash >> end) {
    ranges.push_back({start, end});
  }

  std::sort(ranges.begin(), ranges.end());

  std::cout << "Part 1: " << part1(ranges) << std::endl;
  std::cout << "Part 2: " << part2(ranges) << std::endl;

  return 0;
}