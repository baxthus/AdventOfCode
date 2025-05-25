#include <fstream>
#include <iostream>
#include <istream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

struct Instruction {
  std::string op;
  std::string reg;
  int offset;
};

std::vector<Instruction> read_instructions(const std::string &filename) {
  std::vector<Instruction> instructions;
  std::ifstream file(filename);
  std::string line;

  while (std::getline(file, line)) {
    Instruction instr;
    std::istringstream iss(line);
    iss >> instr.op;

    if (instr.op == "hlf" || instr.op == "tpl" || instr.op == "inc") {
      iss >> instr.reg;
    } else if (line.substr(0, 3) == "jmp") {
      iss >> instr.offset;
    } else if (line.substr(0, 3) == "jie" || line.substr(0, 3) == "jio") {
      iss >> instr.reg;
      instr.reg.pop_back();
      iss >> instr.offset;
    }
    instructions.push_back(instr);
  }

  return instructions;
}

int execute_program(const std::vector<Instruction> &instructions,
                    bool part_2 = false) {
  std::unordered_map<std::string, int> registers = {{"a", part_2 ? 1 : 0},
                                                    {"b", 0}};
  int pc = 0;

  while (pc >= 0 && pc < instructions.size()) {
    const Instruction &instr = instructions[pc];

    if (instr.op == "hlf") {
      registers[instr.reg] /= 2;
      pc++;
    } else if (instr.op == "tpl") {
      registers[instr.reg] *= 3;
      pc++;
    } else if (instr.op == "inc") {
      registers[instr.reg]++;
      pc++;
    } else if (instr.op == "jmp") {
      pc += instr.offset;
    } else if (instr.op == "jie") {
      if (registers[instr.reg] % 2 == 0) {
        pc += instr.offset;
      } else {
        pc++;
      }
    } else if (instr.op == "jio") {
      if (registers[instr.reg] == 1) {
        pc += instr.offset;
      } else {
        pc++;
      }
    }
  }

  return registers["b"];
}

int main() {
  std::vector<Instruction> instructions = read_instructions("input.txt");
  std::cout << "Part 1: " << execute_program(instructions) << std::endl;
  std::cout << "Part 2: " << execute_program(instructions, true) << std::endl;

  return 0;
}
