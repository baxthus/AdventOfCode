#include <algorithm>
#include <fstream>
#include <iostream>
#include <random>
#include <string>
#include <unordered_set>
#include <utility>
#include <vector>

struct Replacement {
  std::string from;
  std::string to;
  Replacement(std::string f, std::string t) : from(f), to(t) {}
};

std::pair<std::vector<Replacement>, std::string> parse_input(const std::string& filename) {
  std::ifstream file(filename);
  std::vector<Replacement> replacements;
  std::string molecule;
  std::string line;

  while (std::getline(file, line)) {
    if (line.find("=>") != std::string::npos) {
      size_t pos = line.find(" => ");
      replacements.push_back(Replacement(line.substr(0, pos), line.substr(pos + 4)));
    } else if (!line.empty()) {
      molecule = line;
    }
  }

  return {replacements, molecule};
}

std::unordered_set<std::string> mutate(const std::string& molecule, const std::vector<Replacement>& replacements) {
  std::unordered_set<std::string> distinct_molecules;
  for (const auto& rep : replacements) {
    size_t pos = 0;
    while ((pos = molecule.find(rep.from, pos)) != std::string::npos) {
      std::string new_molecule = molecule.substr(0, pos) + rep.to + molecule.substr(pos + rep.from.length());
      distinct_molecules.insert(new_molecule);
      pos += rep.from.length();
    }
  }
  return distinct_molecules;
}

int search(const std::string& molecule, std::vector<Replacement>& replacements) {
  std::string target = molecule;
  int mutations = 0;
  std::random_device rd;
  std::mt19937 gen(rd());

  while (target != "e") {
    std::string tmp = target;
    for (const auto& rep : replacements) {
      size_t index = target.find(rep.to);
      if (index != std::string::npos) {
        target = target.substr(0, index) + rep.from + target.substr(index + rep.to.length());
        mutations++;
        break;
      }
    }

    if (tmp == target) {
      target = molecule;
      mutations = 0;
      std::shuffle(replacements.begin(), replacements.end(), gen);
    }
  }

  return mutations;
}

int main() {
  auto [replacements, molecule] = parse_input("input.txt");

  std::cout << "Part 1: " << mutate(molecule, replacements).size() << std::endl;
  std::cout << "Part 2: " << search(molecule, replacements) << std::endl;

  return 0;
}
