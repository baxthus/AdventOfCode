#include <iostream>
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#include <iomanip>
#include <ios>
#include <openssl/md5.h>
#include <sstream>
#include <string>

std::string md5(const std::string &input) {
  unsigned char result[MD5_DIGEST_LENGTH];
  MD5(reinterpret_cast<const unsigned char *>(input.c_str()), input.length(),
      result);

  std::ostringstream sout;
  sout << std::hex << std::setfill('0');
  for (auto c : result) {
    sout << std::setw(2) << static_cast<int>(c);
  }

  return sout.str();
}

int find_lowest_number(const std::string &input) {
  int number = 1;
  while (true) {
    std::string hash_input = input + std::to_string(number);
    std::string hash = md5(hash_input);
    if (hash.substr(0, 5) == "00000") {
      return number;
    }
    number++;
  }
}

int find_lowest_number_six_zeroes(const std::string &input) {
  int number = 1;
  while (true) {
    std::string hash_input = input + std::to_string(number);
    std::string hash = md5(hash_input);
    if (hash.substr(0, 6) == "000000") {
      return number;
    }
    number++;
  }
}

int main() {
  std::string input = "iwrupvqb";

  std::cout << "Part 1: " << find_lowest_number(input) << std::endl;
  std::cout << "Part 2: " << find_lowest_number_six_zeroes(input) << std::endl;

  return 0;
}
