from dataclasses import dataclass
from typing import Dict, List, Optional
import sys

@dataclass
class Instruction:
  op: str
  x: str
  y: Optional[str] = None

Instructions = List[Instruction]
Registers = Dict[str, int]

def read_instructions() -> Instructions:
  instructions: Instructions = []
  for line in sys.stdin:
    parts = line.strip().split()
    op = parts[0]
    x = parts[1]
    y = parts[2] if len(parts) == 3 else None
    instructions.append(Instruction(op, x, y))
  return instructions

def get_value(operand: str, registers: Registers) -> int:
  if operand.isalpha() and len(operand) == 1:
    return registers[operand]
  else:
    return int(operand)

def execute(instructions: Instructions, registers: Registers):
  pc = 0
  num_instructions = len(instructions)

  while 0 <= pc < num_instructions:
    instr = instructions[pc]

    if instr.op == "cpy":
      if instr.y and instr.y.isalpha() and len(instr.y) == 1:
        registers[instr.y] = get_value(instr.x, registers)
        pc += 1
      else:
        pc += 1
    elif instr.op == "inc":
      if instr.x.isalpha() and len(instr.x) == 1:
        registers[instr.x] += 1
        pc += 1
      else:
        pc += 1
    elif instr.op == "dec":
      if instr.x.isalpha() and len(instr.x) == 1:
        registers[instr.x] -= 1
        pc += 1
      else:
        pc += 1
    elif instr.op == "jnz":
      if instr.y:
        if get_value(instr.x, registers) != 0:
          pc += int(instr.y)
        else:
          pc += 1
      else:
        pc += 1

def main():
  instructions = read_instructions()

  registers: Registers = {"a": 0, "b": 0, "c": 0, "d": 0}
  execute(instructions, registers)
  print(f"Part 1 - Value in register a: {registers['a']}")

  registers = {"a": 0, "b": 0, "c": 1, "d": 0}
  execute(instructions, registers)
  print(f"Part 2 - Value in register a: {registers['a']}")

if __name__ == "__main__":
  main()
