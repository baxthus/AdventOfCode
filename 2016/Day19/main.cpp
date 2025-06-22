#include <cstdint>
#include <iostream>

uint32_t highest_power_of_2(uint32_t n) {
  uint32_t p = 1;
  while (p <= n / 2)
    p *= 2;
  return p;
}

uint32_t part2(uint32_t num_elves) {
  uint32_t p3 = 1;
  while (p3 <= num_elves / 3)
    p3 *= 3;

  if (num_elves == p3)
    return num_elves;

  if (num_elves <= 2 * p3)
    return num_elves - p3;

  return 2 * num_elves - 3 * p3;
}

int main() {
  const uint32_t num_elves = 3017957;

  uint32_t p = highest_power_of_2(num_elves);

  uint32_t l = num_elves - p;

  uint32_t winner = 2 * l + 1;

  std::cout << "Part 1: " << winner << std::endl;

  std::cout << "Part 2: " << part2(num_elves) << std::endl;

  return 0;
}