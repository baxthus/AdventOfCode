#include <algorithm>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

void scramble(std::string &password, const std::string &instruction) {
  std::stringstream ss(instruction);
  std::string word;
  ss >> word;

  if (word == "swap") {
    ss >> word;
    if (word == "position") {
      int pos1, pos2;
      std::string temp;
      ss >> pos1 >> temp >> temp >> pos2;
      std::swap(password[pos1], password[pos2]);
    } else {
      char let1, let2;
      std::string temp;
      ss >> let1 >> temp >> temp >> let2;
      size_t pos1 = password.find(let1);
      size_t pos2 = password.find(let2);
      if (pos1 != std::string::npos && pos2 != std::string::npos) {
        std::swap(password[pos1], password[pos2]);
      }
    }
  } else if (word == "rotate") {
    ss >> word;
    if (word == "left") {
      int steps;
      ss >> steps;
      steps %= password.length();
      std::rotate(password.begin(), password.begin() + steps, password.end());
    } else if (word == "right") {
      int steps;
      ss >> steps;
      steps %= password.length();
      std::rotate(password.rbegin(), password.rbegin() + steps,
                  password.rend());
    } else {
      char letter;
      std::string temp;
      ss >> temp >> temp >> temp >> temp >> letter;
      size_t idx = password.find(letter);
      if (idx != std::string::npos) {
        int rotations = 1 + idx;
        if (idx >= 4) {
          rotations++;
        }
        rotations %= password.length();
        std::rotate(password.rbegin(), password.rbegin() + rotations,
                    password.rend());
      }
    }
  } else if (word == "reverse") {
    int pos1, pos2;
    std::string temp;
    ss >> temp >> pos1 >> temp >> pos2;
    std::reverse(password.begin() + pos1, password.begin() + pos2 + 1);
  } else if (word == "move") {
    int pos1, pos2;
    std::string temp;
    ss >> temp >> pos1 >> temp >> temp >> pos2;
    char c = password[pos1];
    password.erase(pos1, 1);
    password.insert(pos2, 1, c);
  }
}

void unscramble(std::string &password, const std::string &instruction) {
  std::stringstream ss(instruction);
  std::string word;
  ss >> word;

  if (word == "swap") {
    scramble(password, instruction);
  } else if (word == "rotate") {
    ss >> word;
    if (word == "left") {
      int steps;
      ss >> steps;
      steps %= password.length();
      std::rotate(password.rbegin(), password.rbegin() + steps,
                  password.rend());
    } else if (word == "right") {
      int steps;
      ss >> steps;
      steps %= password.length();
      std::rotate(password.begin(), password.begin() + steps, password.end());
    } else {
      char letter;
      std::string temp;
      ss >> temp >> temp >> temp >> temp >> letter;

      std::string original_state = password;
      for (size_t i = 0; i < password.length(); i++) {
        std::rotate(password.begin(), password.begin() + 1, password.end());

        std::string temp_scrambled = password;
        scramble(temp_scrambled, instruction);

        if (temp_scrambled == original_state) {
          break;
        }
      }
    }
  } else if (word == "reverse") {
    scramble(password, instruction);
  } else if (word == "move") {
    int pos1, pos2;
    std::string temp;
    ss >> temp >> pos1 >> temp >> temp >> pos2;

    char c = password[pos2];
    password.erase(pos2, 1);
    password.insert(pos1, 1, c);
  }
}

int main() {
  std::vector<std::string> instructions;
  std::string line;
  while (std::getline(std::cin, line)) {
    instructions.push_back(line);
  }

  std::string password1 = "abcdefgh";
  for (const auto &instruction : instructions) {
    scramble(password1, instruction);
  }
  std::cout << "Part 1: " << password1 << std::endl;

  std::string password2 = "fbgdceah";
  for (auto it = instructions.rbegin(); it != instructions.rend(); ++it) {
    unscramble(password2, *it);
  }
  std::cout << "Part 2: " << password2 << std::endl;

  return 0;
}