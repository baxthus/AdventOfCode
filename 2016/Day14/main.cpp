#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#include <iostream>
#include <openssl/md5.h>
#include <regex>
#include <string>
#include <vector>

std::string md5(const std::string &input) {
  unsigned char digest[MD5_DIGEST_LENGTH];
  MD5((unsigned char *)input.c_str(), input.length(), (unsigned char *)digest);
  char mdString[33];
  for (int i = 0; i < 16; i++)
    sprintf(&mdString[i * 2], "%02x", (unsigned int)digest[i]);
  return std::string(mdString);
}

std::string stretched_md5(const std::string &input) {
  std::string hash = md5(input);
  for (int i = 0; i < 2016; i++)
    hash = md5(hash);
  return hash;
}

bool has_triplet(const std::string &hash, char &triplet_char) {
  std::regex triplet_regex("(.)\\1\\1");
  std::smatch match;
  if (std::regex_search(hash, match, triplet_regex)) {
    triplet_char = match.str(1)[0];
    return true;
  }
  return false;
}

bool has_quintuplet(const std::string &hash, char quintuplet_char) {
  std::string quintuplet(5, quintuplet_char);
  return hash.find(quintuplet) != std::string::npos;
}

int main() {
  std::string salt = "zpqevtbw";
  int index = 0;
  int keys_found = 0;
  std::vector<std::string> hashes;

  while (keys_found < 64) {
    if (index >= hashes.size())
      hashes.push_back(md5(salt + std::to_string(index)));

    char triplet_char;
    if (has_triplet(hashes[index], triplet_char)) {
      for (int i = index + 1; i <= index + 1000; i++) {
        if (i >= hashes.size())
          hashes.push_back(md5(salt + std::to_string(i)));
        if (has_quintuplet(hashes[i], triplet_char)) {
          keys_found++;
          break;
        }
      }
    }
    index++;
  }

  std::cout << "Index of the 64th key: " << index - 1 << std::endl;

  index = 0;
  keys_found = 0;
  hashes.clear();

  while (keys_found < 64) {
    if (index >= hashes.size())
      hashes.push_back(stretched_md5(salt + std::to_string(index)));

    char triplet_char;
    if (has_triplet(hashes[index], triplet_char)) {
      for (int i = index + 1; i <= index + 1000; i++) {
        if (i >= hashes.size())
          hashes.push_back(stretched_md5(salt + std::to_string(i)));
        if (has_quintuplet(hashes[i], triplet_char)) {
          keys_found++;
          break;
        }
      }
    }
    index++;
  }

  std::cout << "Index of the 64th key with stretched hash: " << index - 1
            << std::endl;

  return 0;
}