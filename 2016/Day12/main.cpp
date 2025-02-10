#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

struct Instruction {
  std::string op;
  std::string x;
  std::string y;
};

using Instructions = std::vector<Instruction>;
using Registers = std::unordered_map<std::string, int>;

Instructions read_instructions(const std::string &filename) {
  Instructions instructions;
  std::ifstream file(filename);
  std::string line;

  while (getline(file, line)) {
    std::istringstream iss(line);
    Instruction instr;
    iss >> instr.op >> instr.x >> instr.y;
    instructions.push_back(instr);
  }

  return instructions;
}

int get_value(const std::string &operand, const Registers &registers) {
  if (std::isalpha(operand[0])) {
    return registers.at(operand);
  } else {
    return std::stoi(operand);
  }
}

void execute_program(Instructions &instructions, Registers &registers) {
  int pc = 0;

  while (pc >= 0 && pc < instructions.size()) {
    const Instruction &instr = instructions[pc];

    if (instr.op == "cpy") {
      int value = get_value(instr.x, registers);
      registers[instr.y] = value;
      pc++;
    } else if (instr.op == "inc") {
      registers[instr.x]++;
      pc++;
    } else if (instr.op == "dec") {
      registers[instr.x]--;
      pc++;
    } else if (instr.op == "jnz") {
      int value = get_value(instr.x, registers);
      if (value != 0) {
        pc += std::stoi(instr.y);
      } else {
        pc++;
      }
    }
  }
}

int main() {
  Instructions instructions = read_instructions("input.txt");

  // Part 1
  Registers registers = {{"a", 0}, {"b", 0}, {"c", 0}, {"d", 0}};
  execute_program(instructions, registers);
  std::cout << "Value in register a: " << registers["a"] << std::endl;

  // Part 2
  registers = {{"a", 0}, {"b", 0}, {"c", 1}, {"d", 0}};
  execute_program(instructions, registers);
  std::cout << "Value in register a: " << registers["a"] << std::endl;

  return 0;
}