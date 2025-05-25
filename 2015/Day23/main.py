from dataclasses import dataclass
import sys
from typing import List

@dataclass
class Instruction:
    op: str
    reg: str = ''
    offset: int = 0

def read_instructions() -> List[Instruction]:
    instructions: List[Instruction] = []
    for line in sys.stdin:
        line = line.strip()
        parts = line.split(' ', 1)
        op = parts[0]

        instr = Instruction(op=op)

        if op in ('hlf', 'tpl', 'inc'):
            instr.reg = parts[1]
        elif op == 'jmp':
            instr.offset = int(parts[1])
        elif op in ('jie', 'jio'):
            # Expected format: 'r, +/-offset'
            reg_offset_parts = parts[1].split(', ')
            instr.reg = reg_offset_parts[0]
            instr.offset = int(reg_offset_parts[1])
        else:
            raise ValueError(f"Unknown instruction: {op}")

        instructions.append(instr)
    return instructions

def execute_program(instructions: List[Instruction], part2: bool = False) -> int:
    registers = {'a': 1 if part2 else 0, 'b': 0}
    pc = 0
    num_instructions = len(instructions)

    while 0 <= pc < num_instructions:
        instr = instructions[pc]
        if instr.op == 'hlf':
            if instr.reg not in registers:
                raise ValueError(f"Unknown register: {instr.reg}")
            registers[instr.reg] //= 2
            pc += 1
        elif instr.op == 'tpl':
            if instr.reg not in registers:
                raise ValueError(f"Unknown register: {instr.reg}")
            registers[instr.reg] *= 3
            pc += 1
        elif instr.op == 'inc':
            if instr.reg not in registers:
                raise ValueError(f"Unknown register: {instr.reg}")
            registers[instr.reg] += 1
            pc += 1
        elif instr.op == 'jmp':
            pc += instr.offset
        elif instr.op == 'jie':
            if instr.reg not in registers:
                raise ValueError(f"Unknown register: {instr.reg}")
            if registers[instr.reg] % 2 == 0:
                pc += instr.offset
            else:
                pc += 1
        elif instr.op == 'jio':
            if instr.reg not in registers:
                raise ValueError(f"Unknown register: {instr.reg}")
            if registers[instr.reg] == 1:
                pc += instr.offset
            else:
                pc += 1
        else:
            raise ValueError(f"Unknown instruction: {instr.op}")

    if 'b' not in registers:
        raise ValueError("Register 'b' not found in registers.")

    return registers['b']

def main():
    instructions = read_instructions()

    print(f'Part 1: {execute_program(instructions)}')
    print(f'Part 2: {execute_program(instructions, True)}')

if __name__ == '__main__':
    main()
