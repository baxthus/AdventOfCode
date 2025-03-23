#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#include <iomanip>
#include <iostream>
#include <openssl/md5.h>
#include <sstream>
#include <string>

std::string md5(const std::string &input) {
  unsigned char result[MD5_DIGEST_LENGTH];
  MD5((unsigned char *)input.c_str(), input.length(), result);

  std::ostringstream sout;
  sout << std::hex << std::setfill('0');
  for (auto c : result) {
    sout << std::setw(2) << (int)c;
  }
  return sout.str();
}

std::string find_password(const std::string &door_id) {
  std::string password = "";
  int index = 0;

  while (password.length() < 8) {
    std::string to_hash = door_id + std::to_string(index);
    std::string hash = md5(to_hash);

    if (hash.substr(0, 5) == "00000") {
      password += hash[5];
    }

    index++;
  }

  return password;
}

std::string find_password2(const std::string &door_id) {
  std::string password = "________";
  int index = 0;
  int filled_positions = 0;

  while (filled_positions < 8) {
    std::string to_hash = door_id + std::to_string(index);
    std::string hash = md5(to_hash);

    if (hash.substr(0, 5) == "00000") {
      char position = hash[5];
      if (position >= '0' && position <= '7') {
        int pos = position - '0';
        if (password[pos] == '_') {
          password[pos] = hash[6];
          filled_positions++;
        }
      }
    }

    index++;
  }

  return password;
}

int main() {
  std::string door_id = "ojvtpuvg";

  std::cout << "Part 1: " << find_password(door_id) << std::endl;
  std::cout << "Part 2: " << find_password2(door_id) << std::endl;

  return 0;
}
