import 'dart:io';

void main() async {
  var instructions = await readInstructions('input.txt');
  print('Part 1: ${executeProgram(instructions)}');
  print('Part 2: ${executeProgram(instructions, part2: true)}');
}

int executeProgram(List<Instruction> instructions, {bool part2 = false}) {
  final registers = {'a': part2 ? 1 : 0, 'b': 0};
  var pc = 0;

  while (pc >= 0 && pc < instructions.length) {
    final instr = instructions[pc];

    if (instr.op == 'hlf') {
      registers[instr.reg] = (registers[instr.reg]! / 2).floor();
      pc++;
    } else if (instr.op == 'tpl') {
      registers[instr.reg] = registers[instr.reg]! * 3;
      pc++;
    } else if (instr.op == 'inc') {
      registers[instr.reg] = registers[instr.reg]! + 1;
      pc++;
    } else if (instr.op == 'jmp') {
      pc += instr.offset;
    } else if (instr.op == 'jie') {
      if (registers[instr.reg]! % 2 == 0) {
        pc += instr.offset;
      } else {
        pc++;
      }
    } else if (instr.op == 'jio') {
      if (registers[instr.reg] == 1) {
        pc += instr.offset;
      } else {
        pc++;
      }
    }
  }

  return registers['b']!;
}

Future<List<Instruction>> readInstructions(String filename) async {
  final List<Instruction> instructions = [];
  final lines = await File(filename).readAsLines();

  for (var line in lines) {
    final parts = line.split(' ');
    final op = parts[0];
    var reg = '';
    var offset = 0;

    if (op == 'hlf' || op == 'tpl' || op == 'inc') {
      reg = parts[1];
    } else if (op == 'jmp') {
      offset = int.parse(parts[1]);
    } else if (op == 'jie' || op == 'jio') {
      reg = parts[1].substring(0, parts[1].length - 1);
      offset = int.parse(parts[2]);
    }

    instructions.add(Instruction(op, reg, offset));
  }

  return instructions;
}

class Instruction {
  String op;
  String reg;
  int offset;

  Instruction(this.op, this.reg, this.offset);
}
