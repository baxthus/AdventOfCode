#include <algorithm>
#include <iostream>
#include <string>

std::string generate_dragon_curve_data(const std::string &input,
                                       size_t length) {
  std::string data = input;
  while (data.length() < length) {
    std::string b = data;
    std::reverse(b.begin(), b.end());
    for (char &c : b) {
      c = (c == '0') ? '1' : '0';
    }
    data += '0' + b;
  }
  return data.substr(0, length);
}

std::string compute_checksum(const std::string &data) {
  std::string checksum = data;
  while (checksum.length() % 2 == 0) {
    std::string new_checksum;
    for (size_t i = 0; i < checksum.length(); i += 2) {
      new_checksum += (checksum[i] == checksum[i + 1]) ? '1' : '0';
    }
    checksum = new_checksum;
  }
  return checksum;
}

int main() {
  std::string input = "11011110011011101";
  size_t disk_length = 272;

  std::string data = generate_dragon_curve_data(input, disk_length);
  std::string checksum = compute_checksum(data);

  std::cout << "Part 1: " << checksum << std::endl;

  disk_length = 35651584;

  data = generate_dragon_curve_data(input, disk_length);
  checksum = compute_checksum(data);

  std::cout << "Part 2: " << checksum << std::endl;

  return 0;
}